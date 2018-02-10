module Halunke
  module Runtime
    class HClass
      attr_reader :name

      def initialize(name, allowed_attributes, instance_methods, class_methods, native)
        @name = name
        @allowed_attributes = allowed_attributes
        @instance_methods = instance_methods
        @class_methods = class_methods
        @native = native
      end

      class << self
        def receive_message(context, message_name, message_value)
          raise "Class Class has no method to respond to message '#{message_name}'" unless message_name == "new attributes methods"

          name = determine_name(message_value[0])
          allowed_attributes = determine_allowed_attributes(message_value[1])
          instance_methods = determine_instance_methods(message_value[2])
          class_methods = {}

          context[name] = HClass.new(name, allowed_attributes, instance_methods, class_methods, false)
        end

        private

        def determine_name(hstring)
          hstring.ruby_value
        end

        def determine_allowed_attributes(harray)
          harray.ruby_value.map(&:ruby_value)
        end

        def determine_instance_methods(hdictionary)
          instance_methods = {}
          hdictionary.ruby_value.each_pair do |method_name, fn|
            instance_methods[method_name.ruby_value] = fn
          end
          instance_methods
        end
      end

      def receive_message(_context, message_name, message_value)
        raise "Class #{@name} has no method to respond to message '#{message_name}'" unless message_name == "new"

        create_instance(message_value[0])
      end

      def allowed_attribute?(attribute_name)
        @allowed_attributes.include? attribute_name
      end

      def create_instance(value = nil)
        if native?
          HNativeObject.new(self, value)
        else
          HObject.new(self, value ? value.ruby_value : {})
        end
      end

      def lookup(message)
        @instance_methods.fetch(message)
      rescue KeyError
        raise "Class #{@name} has no method to respond to message '#{message}'"
      end

      def inspect(_context)
        "#<Class #{@name}>"
      end

      def native?
        @native
      end
    end
  end
end
