require "pathname"
require "halunke/parser"
require "halunke/runtime"

module Halunke
  class Interpreter
    attr_reader :root_context

    def initialize
      @parser = Parser.new
      @root_context = Context.new

      @root_context["Class"] = Halunke::Runtime::HClass
      @root_context["Function"] = Halunke::Runtime::HFunction
      @root_context["Number"] = Halunke::Runtime::HNumber
      @root_context["String"] = Halunke::Runtime::HString
      @root_context["Array"] = Halunke::Runtime::HArray
      @root_context["Dictionary"] = Halunke::Runtime::HDictionary
      @root_context["UnassignedBareword"] = Halunke::Runtime::HUnassignedBareword

      preludes.each do |prelude|
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

    class Context
      attr_reader :parent

      def initialize(parent = nil)
        @parent = parent
        @context = {}
      end

      def []=(name, value)
        @context[name] = value
      end

      def [](name)
        @context.fetch(name)
      rescue KeyError
        raise "Undefined bareword '#{name}'" if @parent.nil?
        @parent[name]
      end

      def key?(name)
        @context.key?(name)
      end

      def create_child
        Context.new(self)
      end
    end
  end
end
