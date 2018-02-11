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
      @root_context["stdio"] = Halunke::Runtime::HStdio.create_instance
      @root_context["web"] = Halunke::Runtime::HWeb.create_instance

      preludes.each do |prelude|
        self.eval(prelude)
      end
    end

    def eval(str, repl: false)
      nodes = @parser.parse(str)
      nodes.eval(root_context).inspect(root_context)
    rescue HError => err
      show_occurrence(str, err: err, repl: repl)

      puts err
      exit(1) unless repl
      nil
    end

    def preludes
      [
        Pathname.new(__dir__).join("runtime", "true.hal").read,
        Pathname.new(__dir__).join("runtime", "false.hal").read
      ]
    end

    def show_occurrence(str, err:, repl:)
      ts = err.ts
      te = err.te

      line, line_number = str.lines.each_with_index.find do |candidate, _line_number|
        if ts < candidate.length
          te = candidate.length - 1 if te > candidate.length
          true
        else
          ts -= candidate.length
          te -= candidate.length
          false
        end
      end

      prefix = repl ? ">> " : "#{line_number + 1} | "

      puts "#{prefix}#{line}" if !repl

      puts " " * (ts + prefix.length) + "^" * (te - ts)
    end

    class Context
      attr_reader :parent

      def initialize(parent = nil)
        @parent = parent
        @context = {}
      end

      def []=(name, value)
        raise "Bareword #{name} is already assigned" if key? name
        @context[name] = value
      end

      def [](name)
        @context.fetch(name)
      rescue KeyError
        raise "Bareword '#{name} is unassigned'" if @parent.nil?
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
