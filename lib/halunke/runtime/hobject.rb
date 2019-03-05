require "halunke/source_code_position"

module Halunke
  module Runtime
    class HObject
      attr_reader :dict
      attr_reader :runtime_class
      attr_reader :source_code_position

      def initialize(runtime_class, dict, source_code_position:)
        @runtime_class = runtime_class
        @dict = {}
        @source_code_position = source_code_position
        dict.each_pair do |hkey, value|
          key = hkey.ruby_value
          raise "Unknown attribute '#{key}' for #{@runtime_class.name}" unless @runtime_class.allowed_attribute? key
          @dict[key] = value
        end
      end

      def receive_message(context, message_name, message_value, source_code_position: NullSourceCodePosition.new)
        if message_name == "@ else"
          @dict.fetch(message_value[0].ruby_value, message_value[1])
        else
          m = @runtime_class.lookup(message_name)
          m.receive_message(context, "call", [HArray.create_instance([self].concat(message_value))])
        end
      rescue KeyError
        raise HUnknownMessage.new(self.inspect(context), message_name, @runtime_class.instance_methods.keys, source_code_position)
      end

      def inspect(context)
        receive_message(context, "inspect", []).ruby_value
      end
    end
  end
end
