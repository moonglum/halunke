require "halunke/source_code_position"

module Halunke
  module Runtime
    class HFunction
      def initialize(signature, fn)
        @signature = signature
        @fn = fn
      end

      def receive_message(parent_context, message_name, message_value, source_code_position: NullSourceCodePosition.new)
        raise HUnknownMessage.new(self.inspect(parent_context), message_name, ["call"], source_code_position) unless message_name == "call"

        context = parent_context.create_child
        args = message_value[0].ruby_value

        @signature.zip(args).each do |name, value|
          context[name.to_s] = value
        end

        @fn.call(context)
      end

      def inspect(_context)
        "Function (#{@signature.length})"
      end
    end
  end
end
