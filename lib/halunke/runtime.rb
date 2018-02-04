# This file is not tested directly right now,
# because I'm not sure if this structure is good
# They are all prefixed with H to prevent collisions with Ruby's equivalents
module Halunke
  class HClass
    def initialize(name, methods)
      @name = name
      @runtime_methods = methods
    end

    def create_instance(ruby_value)
      HObject.new(self, ruby_value)
    end

    def lookup(message)
      @runtime_methods[message]
    end
  end

  class HObject
    attr_reader :ruby_value

    def initialize(runtime_class, ruby_value)
      @runtime_class = runtime_class
      @ruby_value = ruby_value
    end

    def receive_message(message_name, message_value)
      m = @runtime_class.lookup(message_name)
      m.call(self, message_value)
    end
  end

  class HFunction
    def initialize(fn)
      @fn = fn
    end

    def call(receiver, args)
      @fn.call(receiver, args)
    end
  end

  class HContext
    def initialize
      @context = {}
    end

    def []=(name, value)
      @context[name] = value
    end

    def [](name)
      @context[name]
    end

    def self.root_context
      context = new

      context[:Number] = Halunke::HClass.new(
        "Number",
        "+" => Halunke::HFunction.new(lambda { |receiver, args|
          context[:Number].create_instance(receiver.ruby_value + args.first.ruby_value)
        })
      )

      context[:String] = Halunke::HClass.new(
        "String",
        "reverse" => Halunke::HFunction.new(lambda { |receiver, _args|
          context[:String].create_instance(receiver.ruby_value.reverse)
        }),
        "replace with" => Halunke::HFunction.new(lambda { |receiver, args|
          result = receiver.ruby_value.gsub(
            args[0].ruby_value,
            args[1].ruby_value
          )
          context[:String].create_instance(result)
        })
      )

      context
    end
  end
end
