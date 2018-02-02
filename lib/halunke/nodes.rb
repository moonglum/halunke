require "halunke/runtime"

module Halunke
  Nodes = Struct.new(:nodes) do
    def initialize(nodes = [])
      super(nodes)
    end

    def concat(other)
      Nodes.new(nodes.concat(other.nodes))
    end

    def eval(context)
      val = nil

      nodes.each do |node|
        val = node.eval(context)
      end

      val
    end
  end

  LiteralNode = Struct.new(:value)

  class NumberNode < LiteralNode
    def eval(context)
      context[:Number].create_instance(value)
    end
  end

  class StringNode < LiteralNode
    def eval(context)
      context[:String].create_instance(value)
    end
  end

  class BarewordNode < LiteralNode
  end

  MessageSendNode = Struct.new(:receiver, :message) do
    def eval(context)
      receiver.eval(context).receive_message(*message.eval(context))
    end
  end

  MessageNode = Struct.new(:nodes) do
    def eval(context)
      case nodes.length
      when 1 then [nodes[0].value, []]
      when 2 then [nodes[0].value, [nodes[1].eval(context)]]
      else raise "Not implemented"
      end
    end
  end
end
