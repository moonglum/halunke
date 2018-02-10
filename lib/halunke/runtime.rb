# This file is not tested directly right now,
# because I'm not sure if this structure is good
# They are all prefixed with H to prevent collisions with Ruby's equivalents
module Halunke
  class HClass
    attr_reader :name

    def initialize(name, allowed_attributes, methods)
      @name = name
      @allowed_attributes = allowed_attributes
      @runtime_methods = methods
    end

    def self.receive_message(context, message_name, message_value)
      raise "Class Class has no method to respond to message '#{message_name}'" unless message_name == "new attributes methods"

      name = message_value[0].ruby_value

      allowed_attributes = message_value[1].ruby_value.map(&:ruby_value)

      methods = {}
      message_value[2].ruby_value.each_pair do |method_name, fn|
        methods[method_name.ruby_value] = fn
      end

      context[name] = HClass.new(name, allowed_attributes, methods)
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
      @runtime_methods.fetch(message)
    rescue KeyError
      raise "Class #{@name} has no method to respond to message '#{message}'"
    end

    def inspect(_context)
      "#<Class #{@name}>"
    end
  end

  class HObject
    attr_reader :dict

    def initialize(runtime_class, dict)
      @runtime_class = runtime_class
      @dict = {}
      dict.each_pair do |hkey, value|
        key = hkey.ruby_value
        raise "Unknown attribute '#{key}' for #{@runtime_class.name}" unless @runtime_class.allowed_attribute? key
        @dict[key] = value
      end
    end

    def receive_message(context, message_name, message_value)
      if message_name == "@ else"
        @dict.fetch(message_value[0].ruby_value, message_value[1])
      else
        m = @runtime_class.lookup(message_name)
        m.receive_message(context, "call", [HArray.create_instance([self].concat(message_value))])
      end
    end

    def inspect(context)
      receive_message(context, "inspect", []).ruby_value
    end
  end

  class HNativeObject
    attr_reader :ruby_value

    def initialize(runtime_class, ruby_value = nil)
      @runtime_class = runtime_class
      @ruby_value = ruby_value
    end

    def receive_message(context, message_name, message_value)
      m = @runtime_class.lookup(message_name)
      m.receive_message(context, "call", [HArray.create_instance([self].concat(message_value))])
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

    def receive_message(parent_context, message_name, message_value)
      raise "Class Function has no method to respond to message '#{message_name}'" unless message_name == "call"

      context = parent_context.create_child
      args = message_value[0].ruby_value

      @signature.zip(args).each do |name, value|
        context[name.to_s] = value
      end

      @fn.call(context)
    end

    def inspect(_context)
      "#<Function (#{@signature.length})>"
    end
  end

  class HContext
    def initialize(parent_context = nil)
      @parent_context = parent_context
      @context = {}
    end

    def []=(name, value)
      @context[name] = value
    end

    def [](name)
      @context.fetch(name)
    rescue KeyError
      raise "Undefined bareword '#{name}'" if @parent_context.nil?
      @parent_context[name]
    end

    def parent
      @parent_context
    end

    def key?(name)
      @context.key?(name)
    end

    def create_child
      HContext.new(self)
    end

    def self.root_context
      context = new

      context["Class"] = HClass
      context["Number"] = HNumber
      context["String"] = HString
      context["Array"] = HArray
      context["Dictionary"] = HDictionary
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
    [],
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
      float_value = context["self"].ruby_value.to_f
      float_value = float_value.to_i if float_value.to_i == float_value
      HString.create_instance(float_value.to_s)
    })
  )

  HString = HClass.new(
    "String",
    [],
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
    [],
    "inspect" => HFunction.new([:self], lambda { |context|
      inspected_members = context["self"].ruby_value.map { |member| member.inspect(context) }
      HString.create_instance("[#{inspected_members.join(' ')}]")
    }),
    "=" => HFunction.new([:self, :other], lambda { |context|
      return HFalse.create_instance if context["self"].ruby_value.length != context["other"].ruby_value.length

      context["self"].ruby_value.zip(context["other"].ruby_value).map do |a, b|
        a.receive_message(context.parent, "=", [b])
      end.reduce(HTrue.create_instance) do |memo, value|
        memo.receive_message(context, "and", [value])
      end
    }),
    "map" => HFunction.new([:self, :fn], lambda { |context|
      return HArray.create_instance(context["self"].ruby_value.map do |x|
        context["fn"].receive_message(context, "call", [HArray.create_instance([x])])
      end)
    })
  )

  HDictionary = HClass.new(
    "Dictionary",
    [],
    "inspect" => HFunction.new([:self], lambda { |context|
      x = []
      context["self"].ruby_value.each_pair do |key, value|
        x.push(key.inspect(context))
        x.push(value.inspect(context))
      end
      HString.create_instance("@[#{x.join(' ')}]")
    }),
    "@ else" => HFunction.new([:self, :search, :fallback], lambda { |context|
      result = context["self"].ruby_value.find do |key, _value|
        key.receive_message(context, "=", [context["search"]]).inspect(context) == "true"
      end
      result ? result[1] : context["fallback"]
    })
  )

  HUnassignedBareword = HClass.new(
    "UnassignedBareword",
    [],
    "=" => HFunction.new([:self, :other], lambda { |context|
      context.parent[context["self"].ruby_value] = context["other"]
      HTrue.create_instance
    }),
    "inspect" => HFunction.new([:self], lambda { |context|
      HString.create_instance("'#{context["self"].ruby_value}")
    })
  )

  HTrue = HClass.new(
    "True",
    [],
    "and" => HFunction.new([:self, :other], lambda { |context|
      context["other"]
    }),
    "or" => HFunction.new([:self, :other], lambda { |context|
      context["self"]
    }),
    "then else" => HFunction.new([:self, :true_branch, :false_branch], lambda { |context|
      context["true_branch"].receive_message(context, "call", [HArray.create_instance([])])
    }),
    "inspect" => HFunction.new([:self], lambda {|context|
      HString.create_instance("true")
    })
  )

  HFalse = HClass.new(
    "False",
    [],
    "and" => HFunction.new([:self, :other], lambda { |context|
      context["self"]
    }),
    "or" => HFunction.new([:self, :other], lambda { |context|
      context["other"]
    }),
    "then else" => HFunction.new([:self, :true_branch, :false_branch], lambda { |context|
      context["false_branch"].receive_message(context, "call", [HArray.create_instance([])])
    }),
    "inspect" => HFunction.new([:self], lambda {|context|
      HString.create_instance("false")
    })
  )
end
