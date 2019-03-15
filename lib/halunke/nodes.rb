module Halunke
  Nodes = Struct.new(:nodes) do
    def eval(context)
      nodes.map { |node| node.eval(context) }.last
    end

    def empty?
      nodes.empty?
    end
  end

  NumberNode = Struct.new(:value, :ts, :te) do
    def eval(context)
      context["Number"].create_instance(value)
    end

    def ==(other)
      other.is_a?(NumberNode) &&
        value == other.value
    end
  end

  StringNode = Struct.new(:value, :ts, :te) do
    def eval(context)
      context["String"].create_instance(value)
    end

    def ==(other)
      other.is_a?(StringNode) &&
        value == other.value
    end
  end

  BarewordNode = Struct.new(:value, :ts, :te) do
    def eval(context)
      context[value]
    rescue KeyError
      raise HUnassignedBareword.new("Bareword '#{value} is unassigned", source_code_position)
    end

    def ==(other)
      other.is_a?(BarewordNode) &&
        value == other.value
    end

    private

    def source_code_position
      SourceCodePosition.new(ts, te)
    end
  end

  UnassignedNode = Struct.new(:node, :ts, :te) do
    def eval(context)
      context["UnassignedBareword"].create_instance(node.value, source_code_position: source_code_position)
    end

    def ==(other)
      other.is_a?(UnassignedNode) &&
        node == other.node
    end

    private

    def source_code_position
      SourceCodePosition.new(ts, te)
    end
  end

  FunctionNode = Struct.new(:params, :body, :ts, :te) do
    def eval(context)
      raise HEmptyFunction.new("This function would not return anything, in Halunke every function needs to return something.", source_code_position) if body.empty?
      signature = params.nodes.map(&:node).map(&:value)

      context["Function"].new(signature, lambda { |call_context|
        body.eval(call_context)
      })
    end

    def ==(other)
      other.is_a?(FunctionNode) &&
        params == other.params &&
        body == other.body
    end

    private

    def source_code_position
      SourceCodePosition.new(ts, te)
    end
  end

  ArrayNode = Struct.new(:nodes, :ts, :te) do
    def eval(context)
      context["Array"].create_instance(nodes.map { |node| node.eval(context) })
    end

    def ==(other)
      other.is_a?(ArrayNode) &&
        nodes == other.nodes
    end
  end

  DictionaryNode = Struct.new(:nodes, :ts, :te) do
    def eval(context)
      # TODO Raise exception when number of elements isn't even
      hash = {}
      nodes.each_slice(2) do |key, value|
        hash[key.eval(context)] = value.eval(context)
      end
      context["Dictionary"].create_instance(hash)
    end

    def ==(other)
      other.is_a?(DictionaryNode) &&
        nodes == other.nodes
    end
  end

  MessageSendNode = Struct.new(:nodes, :ts, :te) do
    def eval(context)
      message_name, message_value = parse_message(context)
      receiver.eval(context).receive_message(context, message_name, message_value,
                                             source_code_position: source_code_position)
    end

    def ==(other)
      other.is_a?(MessageSendNode) &&
        nodes == other.nodes
    end

    private

    def source_code_position
      SourceCodePosition.new(ts, te)
    end

    def receiver
      raise HInvalidMessage.new("This message has no receiver", source_code_position) if nodes.length == 0
      @receiver ||= nodes[0]
    end

    def parse_message(context)
      if message_nodes.length == 1
        if message_nodes[0].is_a? NumberNode
          # hack to allow expressions like (1+5)
          ["+", [message_nodes[0].eval(context)]]
        elsif message_nodes[0].is_a? BarewordNode
          [message_nodes[0].value, []]
        else
          # TODO: Underline the offending node, not the entire message
          raise HInvalidMessage.new("The key #{message_nodes[0].eval(context).inspect(context)} is not a bareword", source_code_position)
        end
      else
        name = []
        message = []
        message_nodes.each_slice(2) do |name_part, value|
          # TODO: Underline the offending node, not the entire message
          raise HInvalidMessage.new("The key #{name_part.eval(context).inspect(context)} is not a bareword", source_code_position) unless name_part.is_a? BarewordNode
          # TODO: Underline the offending node, not the entire message
          raise HInvalidMessage.new("Wrong number", source_code_position) if value.nil?
          name.push(name_part.value)
          message.push(value.eval(context))
        end
        [name.join(" "), message]
      end
    end

    def message_nodes
      raise HInvalidMessage.new("You are sending an empty message", source_code_position) if nodes.length == 1
      @message_nodes ||= nodes.drop(1)
    end
  end
end
