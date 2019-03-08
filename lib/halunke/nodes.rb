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
      source_code_position = SourceCodePosition.new(ts, te)
      raise HUnassignedBareword.new("Bareword '#{value} is unassigned", source_code_position)
    end

    def ==(other)
      other.is_a?(BarewordNode) &&
        value == other.value
    end
  end

  UnassignedNode = Struct.new(:node, :ts, :te) do
    def eval(context)
      context["UnassignedBareword"].create_instance(node.value, source_code_position: SourceCodePosition.new(ts, te))
    end

    def ==(other)
      other.is_a?(UnassignedNode) &&
        node == other.node
    end
  end

  FunctionNode = Struct.new(:params, :body, :ts, :te) do
    def eval(context)
      raise HEmptyFunction.new("This function would not return anything, in Halunke every function needs to return something.", SourceCodePosition.new(ts, te)) if body.empty?
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
      receiver = nodes[0]
      message_nodes = nodes.drop(1)
      message_name, message_value = parse_message(message_nodes, context)
      receiver.eval(context).receive_message(context, message_name, message_value,
                                             source_code_position: SourceCodePosition.new(ts, te))
    end

    def ==(other)
      other.is_a?(MessageSendNode) &&
        nodes == other.nodes
    end

    def parse_message(message_nodes, context)
      if message_nodes.length == 1
        if message_nodes[0].is_a? NumberNode
          # hack to allow expressions like (1+5)
          ["+", [message_nodes[0].eval(context)]]
        else
          [message_nodes[0].value, []]
        end
      elsif message_nodes.length.even?
        name = []
        message = []
        message_nodes.each_slice(2) do |name_part, value|
          name.push(name_part.value)
          message.push(value.eval(context))
        end
        [name.join(" "), message]
      else
        raise "Parse Error"
      end
    end
  end
end
