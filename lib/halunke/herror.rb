require "rubygems/text"

module Halunke
  class HError < StandardError
    attr_reader :message
    attr_reader :source_code_position

    def initialize(message, source_code_position)
      @message = message
      @source_code_position = source_code_position
      super(message)
    end
  end

  class HUnknownMessage < HError
    include Gem::Text

    def initialize(receiver, message_name, receivable_messages, source_code_position)
      message = [
        "#{receiver} received the message `#{message_name}`. It doesn't know how to handle that.",
        did_you_mean(receivable_messages, message_name)
      ].join("\n")

      super(message, source_code_position)
    end

    private

    def did_you_mean(receivable_messages, message_name)
      guess = receivable_messages.min_by { |m| levenshtein_distance(m, message_name) }

      if levenshtein_distance(guess, message_name) < 5
        "Did you mean `#{guess}`?"
      else
        "It supports the following messages: #{receivable_messages.join(", ")}"
      end
    end
  end
end
