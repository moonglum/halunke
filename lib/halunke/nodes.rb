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
      context["Number"].create_instance(value,
                                        source_code_position: source_code_position)
    end

    def ==(other)
      other.is_a?(NumberNode) &&
        value == other.value
    end

    def source_code_position
      SourceCodePosition.new(ts, te)
    end
  end

  StringNode = Struct.new(:value, :ts, :te) do
    def eval(context)
      context["String"].create_instance(value,
                                        source_code_position: source_code_position)
    end

    def ==(other)
      other.is_a?(StringNode) &&
        value == other.value
    end

    def source_code_position
      SourceCodePosition.new(ts, te)
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

    def source_code_position
      SourceCodePosition.new(ts, te)
    end
  end

  DictionaryNode = Struct.new(:nodes, :ts, :te) do
    def eval(context)
      # TODO Raise exception when number of elements isn't even
      hash = {}
      nodes.each_slice(2) do |key, value|
        hash[key.eval(context)] = value.eval(context)
      end
      context["Dictionary"].create_instance(hash,
                                            source_code_position: source_code_position)
    end

    def ==(other)
      other.is_a?(DictionaryNode) &&
        nodes == other.nodes
    end

    def source_code_position
      SourceCodePosition.new(ts, te)
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

    def source_code_position
      SourceCodePosition.new(ts, te)
    end

    private

    def receiver
      raise HInvalidMessage.new("This message has no receiver", source_code_position) if nodes.length == 0
      @receiver ||= nodes[0]
    end

    def parse_message(context)
      if message_nodes.length == 1
        # hack to allow expressions like (1+5)
        return ["+", [message_nodes[0].eval(context)]] if message_nodes[0].is_a? NumberNode
        return [message_nodes[0].value, []] if message_nodes[0].is_a? BarewordNode

        raise HInvalidMessage.new("This is not a bareword", message_nodes[0].source_code_position)
      end

      name = []
      message = []
      message_nodes.each_slice(2) do |name_part, value|
        raise HInvalidMessage.new("This is not a bareword", name_part.source_code_position) unless name_part.is_a? BarewordNode
        raise HInvalidMessage.new("This bareword has no according argument", name_part.source_code_position) if value.nil?
        name << name_part
        message << value
      end
      [name.map(&:value).join(" "), message.map { |node| node.eval(context) }]
    end

    def message_nodes
      raise HInvalidMessage.new("You are sending an empty message", source_code_position) if nodes.length == 1
      @message_nodes ||= nodes.drop(1)
    end
  end
end
