require "rubygems/text"

module Halunke
  class HError < StandardError
    attr_reader :message
    attr_reader :ts
    attr_reader :te

    def initialize(message, ts, te)
      @ts = ts
      @te = te
      super(message)
    end
  end

  class HUnknownMessage < HError
    include Gem::Text

    def initialize(context, message_name, obj, ts, te)
      message = [
        "The #{obj.runtime_class.name} #{obj.inspect(context)} received the message `#{message_name}`. It doesn't know how to handle that."
      ]

      guess = obj.runtime_class.receivable_messages.min_by do |m|
        levenshtein_distance(m, message_name)
      end

      if levenshtein_distance(guess, message_name) < 5
        message.push("Did you mean `#{guess}`?")
      else
        message.push("It supports the following messages:")
        message.push(obj.runtime_class.receivable_messages.join(", "))
      end

      super(message.join("\n"), ts, te)
    end
  end
end
