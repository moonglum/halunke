require "halunke/runtime"

module Halunke
  Nodes = Struct.new(:nodes) do
    def initialize(nodes = [])
      super(nodes)
    end

    def concat(other)
      Nodes.new(nodes.concat(other.nodes))
    end
  end

  LiteralNode = Struct.new(:value)

  class NumberNode < LiteralNode
  end

  class StringNode < LiteralNode
  end

  class BarewordNode < LiteralNode
  end

  MessageSendNode = Struct.new(:receiver, :message)

  MessageNode = Struct.new(:nodes)
end
