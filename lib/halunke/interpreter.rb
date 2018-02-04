require "halunke/parser"

module Halunke
  class Interpreter
    def initialize
      @parser = Parser.new
      @context = HContext.root_context
    end

    def eval(str)
      nodes = @parser.parse(str)
      nodes.eval(@context).ruby_value
    end
  end
end
