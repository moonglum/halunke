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

    def inspect(context)
      receive_message(context, "inspect", []).ruby_value
    end
  end

  class HFunction
    def initialize(signature, fn)
      @signature = signature
      @fn = fn
    end

    # TODO: Create a copy of the context
    def call(context, args)
      # Would be nicer to use an HArray here, but this explodes the call stack
      @signature.zip(args).each do |name, value|
        context[name.to_s] = value
      end

      @fn.call(context)
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
    "+" => HFunction.new([:self, :other], lambda { |context|
      HNumber.create_instance(context["self"].ruby_value + context["other"].ruby_value)
    }),
    "<" => HFunction.new([:self, :other], lambda { |context|
      if context["self"].ruby_value < context["other"].ruby_value
        HTrue.create_instance
      else
        HFalse.create_instance
      end
    }),
    ">" => HFunction.new([:self, :other], lambda { |context|
      if context["self"].ruby_value > context["other"].ruby_value
        HTrue.create_instance
      else
        HFalse.create_instance
      end
    }),
    "=" => HFunction.new([:self, :other], lambda { |context|
      if context["self"].ruby_value == context["other"].ruby_value
        HTrue.create_instance
      else
        HFalse.create_instance
      end
    }),
    "inspect" => HFunction.new([:self], lambda { |context|
      HString.create_instance(context["self"].ruby_value.inspect)
    })
  )

  HString = HClass.new(
    "String",
    "reverse" => HFunction.new([:self], lambda { |context|
      HString.create_instance(context["self"].ruby_value.reverse)
    }),
    "replace with" => HFunction.new([:self, :searchword, :replacement], lambda { |context|
      result = context["self"].ruby_value.gsub(
        context["searchword"].ruby_value,
        context["replacement"].ruby_value
      )
      HString.create_instance(result)
    }),
    "=" => HFunction.new([:self, :other], lambda { |context|
      if context["self"].ruby_value == context["other"].ruby_value
        HTrue.create_instance
      else
        HFalse.create_instance
      end
    }),
    "inspect" => HFunction.new([:self], lambda { |context|
      HString.create_instance(context["self"].ruby_value.inspect)
    })
  )

  HArray = HClass.new(
    "Array",
    "inspect" => HFunction.new([:self], lambda { |context|
      inspected_members = context["self"].ruby_value.map { |member| member.inspect(context) }
      HString.create_instance("[#{inspected_members.join(' ')}]")
    }),
    "=" => HFunction.new([:self, :other], lambda { |context|
      return HFalse.create_instance if context["self"].ruby_value.length != context["other"].ruby_value.length

      context["self"].ruby_value.zip(context["other"].ruby_value).map do |a, b|
        a.receive_message(context, "=", [b])
      end.reduce(HTrue.create_instance) do |memo, value|
        memo.receive_message(context, "and", [value])
      end
    })
  )

  HUnassignedBareword = HClass.new(
    "UnassignedBareword",
    "=" => HFunction.new([:self, :other], lambda { |context|
      context[context["self"].ruby_value] = context["other"]
      HTrue.create_instance
    }),
    "inspect" => HFunction.new([:self], lambda { |context|
      HString.create_instance("'#{context["self"].ruby_value}")
    })
  )

  HTrue = HClass.new(
    "True",
    "and" => HFunction.new([:self, :other], lambda { |context|
      context["other"]
    }),
    "or" => HFunction.new([:self, :other], lambda { |context|
      context["self"]
    }),
    "then else" => HFunction.new([:self, :true_branch, :false_branch], lambda { |context|
      context["true_branch"].call(context, [])
    }),
    "inspect" => HFunction.new([:self], lambda {|context|
      HString.create_instance("true")
    })
  )

  HFalse = HClass.new(
    "False",
    "and" => HFunction.new([:self, :other], lambda { |context|
      context["self"]
    }),
    "or" => HFunction.new([:self, :other], lambda { |context|
      context["other"]
    }),
    "then else" => HFunction.new([:self, :true_branch, :false_branch], lambda { |context|
      context["false_branch"].call(context, [])
    }),
    "inspect" => HFunction.new([:self], lambda {|context|
      HString.create_instance("false")
    })
  )
end
