require "halunke/parser"

module Halunke
  class Interpreter
    def initialize
      @parser = Parser.new
      @context = {}
      prelude
    end

    def eval(str)
      nodes = @parser.parse(str)
      nodes.eval(@context).ruby_value
    end

    private

    def prelude
      @context[:Number] = Halunke::NativeClass.new(
        "+" => Halunke::NativeFunction.new(->(receiver, args) {
          @context[:Number].create_instance(receiver.ruby_value + args.first.ruby_value)
        })
      )

      @context[:String] = Halunke::NativeClass.new(
        "reverse" => Halunke::NativeFunction.new(->(receiver, _args) {
          @context[:String].create_instance(receiver.ruby_value.reverse)
        })
      )
    end
  end
end
