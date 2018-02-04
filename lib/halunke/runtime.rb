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

      context["Number"] = Halunke::HClass.new(
        "Number",
        "+" => Halunke::HFunction.new(lambda { |args|
          context["Number"].create_instance(args[0].ruby_value + args[1].ruby_value)
        }),
        "<" => Halunke::HFunction.new(lambda { |args|
          if args[0].ruby_value < args[1].ruby_value
            context["true"]
          else
            context["false"]
          end
        }),
        ">" => Halunke::HFunction.new(lambda { |args|
          if args[0].ruby_value > args[1].ruby_value
            context["true"]
          else
            context["false"]
          end
        })
      )

      context["String"] = Halunke::HClass.new(
        "String",
        "reverse" => Halunke::HFunction.new(lambda { |args|
          context["String"].create_instance(args[0].ruby_value.reverse)
        }),
        "replace with" => Halunke::HFunction.new(lambda { |args|
          result = args[0].ruby_value.gsub(
            args[1].ruby_value,
            args[2].ruby_value
          )
          context["String"].create_instance(result)
        })
      )

      context["True"] = Halunke::HClass.new(
        "True",
        {}
      )

      # TODO: This is not good. This should need no value to be evaluated.
      context["true"] = Halunke::HObject.new(context["True"], true)

      context["False"] = Halunke::HClass.new(
        "False",
        {}
      )

      # TODO: This is not good. This should need no value to be evaluated.
      context["false"] = Halunke::HObject.new(context["False"], false)

      context
    end
  end
end
