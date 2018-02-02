# This file is not tested directly right now,
# because I'm not sure if this structure is good
module Halunke
  class NativeClass
    def initialize(methods)
      @runtime_methods = methods
    end

    def create_instance(ruby_value)
      NativeObject.new(self, ruby_value)
    end

    def lookup(message)
      @runtime_methods[message]
    end
  end

  class NativeObject
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

  class NativeFunction
    def initialize(fn)
      @fn = fn
    end

    def call(receiver, args)
      @fn.call(receiver, args)
    end
  end
end
