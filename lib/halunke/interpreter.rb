require "pathname"
require "halunke/parser"

module Halunke
  class Interpreter
    attr_reader :root_context

    def initialize
      @parser = Parser.new
      @root_context = Runtime::HContext.root_context(self)
      self.preludes.each do |prelude|
        self.eval(prelude)
      end
    end

    def eval(str)
      nodes = @parser.parse(str)
      nodes.eval(root_context).inspect(root_context)
    end

    def preludes
      [
        Pathname.new(__dir__).join("runtime", "true.hal").read,
        Pathname.new(__dir__).join("runtime", "false.hal").read
      ]
    end
  end
end
