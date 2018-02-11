require "halunke/herror"

module Halunke
  module Runtime
    class HNativeObject
      attr_reader :runtime_class
      attr_reader :ruby_value

      def initialize(runtime_class, ruby_value = nil)
        @runtime_class = runtime_class
        @ruby_value = ruby_value
      end

      def receive_message(context, message_name, message_value, ts=nil, te=nil)
        m = @runtime_class.lookup(message_name)
        raise Halunke::HUnknownMessage.new(context, message_name, self, ts, te) if m.nil?
        m.receive_message(context, "call", [HArray.create_instance([self].concat(message_value))])
      end

      def inspect(context)
        receive_message(context, "inspect", []).ruby_value
      end
    end
  end
end
