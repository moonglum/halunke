# This file is not tested directly right now,
# because I'm not sure if this structure is good
# They are all prefixed with H to prevent collisions with Ruby's equivalents
module Halunke
  class HClass
    def initialize(name, methods)
      @name = name
      @runtime_methods = methods
    end

    def create_instance(ruby_value = nil)
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

    def initialize(runtime_class, ruby_value = nil)
      @runtime_class = runtime_class
      @ruby_value = ruby_value
    end

    def receive_message(context, message_name, message_value)
      m = @runtime_class.lookup(message_name)
      m.call(context, [self].concat(message_value))
    end

    # TODO: Is it ok to pass an empty context here?
    def inspect
      receive_message({}, "inspect", []).ruby_value
    end
  end

  class HFunction
    def initialize(fn)
      @fn = fn
    end

    def call(context, args)
      @fn.call(context, args)
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

    def key?(name)
      @context.key?(name)
    end

    def self.root_context
      context = new

      context["Number"] = HNumber
      context["String"] = HString
      context["Array"] = HArray
      context["UnassignedBareword"] = HUnassignedBareword
      context["True"] = HTrue
      context["False"] = HFalse
      context["true"] = HTrue.create_instance
      context["false"] = HFalse.create_instance

      context
    end
  end

  HNumber = HClass.new(
    "Number",
    "+" => HFunction.new(lambda { |context, args|
      HNumber.create_instance(args[0].ruby_value + args[1].ruby_value)
    }),
    "<" => HFunction.new(lambda { |context, args|
      if args[0].ruby_value < args[1].ruby_value
        HTrue.create_instance
      else
        HFalse.create_instance
      end
    }),
    ">" => HFunction.new(lambda { |context, args|
      if args[0].ruby_value > args[1].ruby_value
        HTrue.create_instance
      else
        HFalse.create_instance
      end
    }),
    "=" => HFunction.new(lambda { |context, args|
      if args[0].ruby_value == args[1].ruby_value
        HTrue.create_instance
      else
        HFalse.create_instance
      end
    }),
    "inspect" => HFunction.new(lambda { |context, args|
      HString.create_instance(args[0].ruby_value.inspect)
    })
  )

  HString = HClass.new(
    "String",
    "reverse" => HFunction.new(lambda { |context, args|
      HString.create_instance(args[0].ruby_value.reverse)
    }),
    "replace with" => HFunction.new(lambda { |context, args|
      result = args[0].ruby_value.gsub(
        args[1].ruby_value,
        args[2].ruby_value
      )
      HString.create_instance(result)
    }),
    "=" => HFunction.new(lambda { |context, args|
      if args[0].ruby_value == args[1].ruby_value
        HTrue.create_instance
      else
        HFalse.create_instance
      end
    }),
    "inspect" => HFunction.new(lambda { |context, args|
      HString.create_instance(args[0].ruby_value.inspect)
    })
  )

  HArray = HClass.new(
    "Array",
    "inspect" => HFunction.new(lambda { |context, args|
      inspected_members = args[0].ruby_value.map(&:inspect)
      HString.create_instance("[#{inspected_members.join(' ')}]")
    }),
    "=" => HFunction.new(lambda { |context, args|
      return HFalse.create_instance if args[0].ruby_value.length != args[1].ruby_value.length

      args[0].ruby_value.zip(args[1].ruby_value).map do |a, b|
        a.receive_message(context, "=", [b])
      end.reduce(HTrue.create_instance) do |memo, value|
        memo.receive_message(context, "and", [value])
      end
    })
  )

  HUnassignedBareword = HClass.new(
    "UnassignedBareword",
    "=" => HFunction.new(lambda { |context, args|
      context[args[0].ruby_value] = args[1]
      HTrue.create_instance
    }),
    "inspect" => HFunction.new(lambda { |context, args|
      HString.create_instance("'#{args[0].ruby_value}")
    })
  )

  HTrue = HClass.new(
    "True",
    "and" => HFunction.new(lambda { |context, args|
      args[1]
    }),
    "or" => HFunction.new(lambda { |context, args|
      HTrue.create_instance
    }),
    "then else" => HFunction.new(lambda { |context, args|
      args[1].call(context, [])
    }),
    "inspect" => HFunction.new(lambda {|context, args|
      HString.create_instance("true")
    })
  )

  HFalse = HClass.new(
    "False",
    "and" => HFunction.new(lambda { |context, args|
      HFalse.create_instance
    }),
    "or" => HFunction.new(lambda { |context, args|
      args[1]
    }),
    "then else" => HFunction.new(lambda { |context, args|
      args[2].call(context, [])
    }),
    "inspect" => HFunction.new(lambda {|context, args|
      HString.create_instance("false")
    })
  )
end
