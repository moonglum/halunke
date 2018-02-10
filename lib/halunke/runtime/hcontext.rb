module Halunke
  module Runtime
    class HContext
      def initialize(parent_context = nil)
        @parent_context = parent_context
        @context = {}
      end

      def []=(name, value)
        @context[name] = value
      end

      def [](name)
        @context.fetch(name)
      rescue KeyError
        raise "Undefined bareword '#{name}'" if @parent_context.nil?
        @parent_context[name]
      end

      def parent
        @parent_context
      end

      def key?(name)
        @context.key?(name)
      end

      def create_child
        HContext.new(self)
      end

      def self.root_context(interpreter)
        context = new

        context["Class"] = HClass
        context["Number"] = HNumber
        context["String"] = HString
        context["Array"] = HArray
        context["Dictionary"] = HDictionary
        context["UnassignedBareword"] = HUnassignedBareword

        context
      end
    end
  end
end
