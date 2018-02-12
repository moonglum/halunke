module Halunke
  Nodes = Struct.new(:nodes) do
    def eval(context)
      nodes.map { |node| node.eval(context) }.last
    end

    def empty?
      nodes.empty?
    end

    def to_message
      MessageNode.new(nodes)
    end

    def to_array
      ArrayNode.new(nodes)
    end

    def to_dictionary
      DictionaryNode.new(nodes)
    end
  end

  NumberNode = Struct.new(:value) do
    def eval(context)
      context["Number"].create_instance(value)
    end
  end

  StringNode = Struct.new(:value) do
    def eval(context)
      context["String"].create_instance(value)
    end
  end

  BarewordNode = Struct.new(:value) do
    def eval(context)
      context[value]
    end
  end

  UnassignedNode = Struct.new(:node) do
    def eval(context)
      context["UnassignedBareword"].create_instance(node.value)
    end
  end

  FunctionNode = Struct.new(:params, :body) do
    def eval(context)
      raise "This function would not return anything. That's forbidden." if body.empty?
      signature = params.nodes.map(&:node).map(&:value)

      context["Function"].new(signature, lambda { |call_context|
        body.eval(call_context)
      })
    end
  end

  ArrayNode = Struct.new(:nodes) do
    def eval(context)
      context["Array"].create_instance(nodes.map { |node| node.eval(context) })
    end
  end

  DictionaryNode = Struct.new(:nodes) do
    def eval(context)
      hash = {}
      nodes.each_slice(2) do |key, value|
        hash[key.eval(context)] = value.eval(context)
      end
      context["Dictionary"].create_instance(hash)
    end
  end

  MessageSendNode = Struct.new(:receiver, :message) do
    def eval(context)
      receiver.eval(context).receive_message(context, *message.eval(context))
    end
  end

  MessageNode = Struct.new(:nodes) do
    def eval(context)
      if nodes.length == 1
        [nodes[0].value, []]
      elsif nodes.length.even?
        name = []
        message = []
        nodes.each_slice(2) do |name_part, value|
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
