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
      @runtime_methods.fetch(message)
    rescue KeyError
      raise "Class #{@name} has no method to respond to message '#{message}'"
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
      m.call([self].concat(message_value))
    end
  end

  class HFunction
    def initialize(fn)
      @fn = fn
    end

    def call(args)
      @fn.call(args)
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

      context["Number"] = HNumber
      context["String"] = HString
      context["True"] = HTrue
      context["False"] = HFalse

      # TODO: This is not good. This should need no value to be evaluated.
      context["true"] = HTrue.create_instance(true)

      # TODO: This is not good. This should need no value to be evaluated.
      context["false"] = HFalse.create_instance(false)

      context
    end

    HNumber = HClass.new(
      "Number",
      "+" => HFunction.new(lambda { |args|
        HNumber.create_instance(args[0].ruby_value + args[1].ruby_value)
      }),
      "<" => HFunction.new(lambda { |args|
        if args[0].ruby_value < args[1].ruby_value
          HTrue.create_instance(true)
        else
          HFalse.create_instance(false)
        end
      }),
      ">" => HFunction.new(lambda { |args|
        if args[0].ruby_value > args[1].ruby_value
          HTrue.create_instance(true)
        else
          HFalse.create_instance(false)
        end
      })
    )

    HString = HClass.new(
      "String",
      "reverse" => HFunction.new(lambda { |args|
        HString.create_instance(args[0].ruby_value.reverse)
      }),
      "replace with" => HFunction.new(lambda { |args|
        result = args[0].ruby_value.gsub(
          args[1].ruby_value,
          args[2].ruby_value
        )
        HString.create_instance(result)
      })
    )

    HTrue = HClass.new(
      "True",
      "and" => HFunction.new(lambda { |args|
        args[1]
      }),
      "or" => HFunction.new(lambda { |args|
        HTrue.create_instance(true)
      }),
      "then else" => HFunction.new(lambda { |args|
        args[1].call([])
      })
    )

    HFalse = HClass.new(
      "False",
      "and" => HFunction.new(lambda { |args|
        HFalse.create_instance(false)
      }),
      "or" => HFunction.new(lambda { |args|
        args[1]
      }),
      "then else" => HFunction.new(lambda { |args|
        args[2].call([])
      })
    )
  end
end
