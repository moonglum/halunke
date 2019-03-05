require "halunke/source_code_position"

module Halunke
  module Runtime
    class HNativeObject
      attr_reader :runtime_class
      attr_reader :ruby_value
      attr_reader :source_code_position

      def initialize(runtime_class, ruby_value, source_code_position:)
        @runtime_class = runtime_class
        @ruby_value = ruby_value
        @source_code_position = source_code_position
      end

      def receive_message(context, message_name, message_value, source_code_position: NullSourceCodePosition.new)
        m = @runtime_class.lookup(message_name)
        m.receive_message(context, "call", [HArray.create_instance([self].concat(message_value))])
      rescue KeyError
        raise HUnknownMessage.new(self.inspect(context), message_name, @runtime_class.instance_methods.keys, source_code_position) if m.nil?
      end

      def inspect(context)
        receive_message(context, "inspect", []).ruby_value
      end
    end
  end
end
