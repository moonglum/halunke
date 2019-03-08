$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "halunke"

# NB: Since both parser.rb and tokenizer.rb are generated and contain some mismatched indentations we want to ignore those warnings.
require "warning"
Warning.ignore(/warning: mismatched indentations/, File.expand_path("../../lib/halunke/parser.rb", __FILE__))
Warning.ignore(/warning: mismatched indentations/, File.expand_path("../../lib/halunke/tokenizer.rb", __FILE__))

class ArrayMatching
  def initialize(match)
    @match = match
  end

  def ===(other)
    other.is_a?(Array) &&
      @match.length === other.length &&
      @match.zip(other).all? { |x, y| x === y }
  end
end

def array_matching(*match)
  ArrayMatching.new(match)
end

class NativeObjectMatching
  def initialize(match)
    @match = match
  end

  def ===(other)
    other.is_a?(Halunke::Runtime::HNativeObject) &&
      @match === other.ruby_value
  end
end

def native_object_matching(match)
  NativeObjectMatching.new(match)
end

require "minitest/autorun"
