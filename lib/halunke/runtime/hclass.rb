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

      def self.receive_message(context, message_name, message_value)
        raise "Class Class has no method to respond to message '#{message_name}'" unless message_name == "new attributes methods"

        name = message_value[0].ruby_value

        allowed_attributes = message_value[1].ruby_value.map(&:ruby_value)

        methods = {}
        message_value[2].ruby_value.each_pair do |method_name, fn|
          methods[method_name.ruby_value] = fn
        end

        context[name] = HClass.new(name, allowed_attributes, methods, {}, false)
      end

      # TODO: If a native class receives "new", this doesn't work
      def receive_message(context, message_name, message_value)
        raise "Class #{@name} has no method to respond to message '#{message_name}'" unless message_name == "new"

        dict = case message_value.length
               when 0 then {}
               when 1 then message_value[0].ruby_value
               else raise "Too many arguments"
               end

        HObject.new(self, dict)
      end

      def allowed_attribute?(attribute_name)
        @allowed_attributes.include? attribute_name
      end

      def create_instance(ruby_value = nil)
        HNativeObject.new(self, ruby_value)
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
