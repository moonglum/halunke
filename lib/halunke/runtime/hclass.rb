require "halunke/source_code_position"
require "halunke/herror"

module Halunke
  module Runtime
    class HClass
      attr_reader :name
      attr_reader :instance_methods

      def initialize(name, allowed_attributes, instance_methods, class_methods, native)
        @name = name
        @allowed_attributes = allowed_attributes
        @instance_methods = instance_methods
        @class_methods = class_methods
        @native = native
      end

      class << self
        def receive_message(context, message_name, message_value, source_code_position: NullSourceCodePosition.new)
          case message_name
          when "new attributes methods class_methods"
            name = determine_name(message_value[0])
            allowed_attributes = determine_allowed_attributes(message_value[1])
            instance_methods = determine_methods(message_value[2])
            class_methods = determine_methods(message_value[3])
          when "new attributes methods"
            name = determine_name(message_value[0])
            allowed_attributes = determine_allowed_attributes(message_value[1])
            instance_methods = determine_methods(message_value[2])
            class_methods = {}
          when "new methods"
            name = determine_name(message_value[0])
            allowed_attributes = []
            instance_methods = determine_methods(message_value[1])
            class_methods = {}
          else
            known_messages = ["new attributes methods class_methods", "new attributes methods", "new methods"]
            raise HUnknownMessage.new("Class", message_name, known_messages, source_code_position)
          end

          context[name] = HClass.new(name, allowed_attributes, instance_methods, class_methods, false)
        end

        private

        def determine_name(hstring)
          hstring.ruby_value
        end

        def determine_allowed_attributes(harray)
          harray.ruby_value.map(&:ruby_value)
        end

        def determine_methods(hdictionary)
          instance_methods = {
            "inspect" => HFunction.new([:self], lambda { |context|
              hself = context["self"]

              attributes = hself.dict.map do |key, value|
                %Q{"#{key}" #{value.inspect(context)}}
              end

              HString.create_instance("#{hself.runtime_class.name} @[#{attributes.join(' ')}]")
            })
          }
          hdictionary.ruby_value.each_pair do |method_name, fn|
            instance_methods[method_name.ruby_value] = fn
          end
          instance_methods
        end
      end

      def receive_message(context, message_name, message_value, source_code_position: NullSourceCodePosition.new)
        if message_name == "new" && !native?
          create_instance(message_value[0], source_code_position: source_code_position)
        elsif @class_methods.key? message_name
          m = @class_methods[message_name]
          m.receive_message(context, "call", [HArray.create_instance([self].concat(message_value))],
                            source_code_position: source_code_position)
        else
          raise HUnknownMessage.new(self.inspect(context), message_name, @class_methods.keys, source_code_position)
        end
      end

      def allowed_attribute?(attribute_name)
        @allowed_attributes.include? attribute_name
      end

      def create_instance(value = nil, source_code_position: NullSourceCodePosition.new)
        if native?
          HNativeObject.new(self, value, source_code_position: source_code_position)
        else
          HObject.new(self, value ? value.ruby_value : {}, source_code_position: source_code_position)
        end
      end

      def lookup(message)
        @instance_methods.fetch(message)
      end

      def inspect(_context)
        "Class #{@name}"
      end

      def runtime_class
        self
      end

      def native?
        @native
      end
    end
  end
end
