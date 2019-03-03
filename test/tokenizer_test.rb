require "test_helper"
require "halunke/tokenizer"

class TokenizerTest < Minitest::Test
  def setup
    @tokenizer = Halunke::Tokenizer.new
  end

  def test_number
    assert_equal [[:NUMBER, 82r]], @tokenizer.tokenize("82")
  end

  def test_negative_number
    assert_equal [[:NUMBER, -82r]], @tokenizer.tokenize("-82")
  end

  def test_rational_number
    assert_equal [[:NUMBER, 0.9r]], @tokenizer.tokenize("0.9")
  end

  def test_string
    assert_equal [[:STRING, "82"]], @tokenizer.tokenize('"82"')
  end

  def test_identifier
    assert_equal [[:BAREWORD, "name"]], @tokenizer.tokenize("name")
  end

  def test_open_parenthesis
    assert_equal [[:OPEN_PAREN, "("]], @tokenizer.tokenize("(")
  end

  def test_closing_parenthesis
    assert_equal [[:CLOSE_PAREN, ")"]], @tokenizer.tokenize(")")
  end

  def test_open_curly
    assert_equal [[:OPEN_CURLY, "{"]], @tokenizer.tokenize("{")
  end

  def test_closing_curly
    assert_equal [[:CLOSE_CURLY, "}"]], @tokenizer.tokenize("}")
  end

  def test_open_bracket
    assert_equal [[:OPEN_BRACKET, "["]], @tokenizer.tokenize("[")
  end

  def test_closing_bracket
    assert_equal [[:CLOSE_BRACKET, "]"]], @tokenizer.tokenize("]")
  end

  def test_open_dict_bracket
    assert_equal [[:OPEN_DICT_BRACKET, "@["]], @tokenizer.tokenize("@[")
  end

  def test_bar
    assert_equal [[:BAR, "|"]], @tokenizer.tokenize("|")
  end

  def test_plus
    assert_equal [[:BAREWORD, "+"]], @tokenizer.tokenize("+")
  end

  def test_minus
    assert_equal [[:BAREWORD, "-"]], @tokenizer.tokenize("-")
  end

  def test_less_than
    assert_equal [[:BAREWORD, "<"]], @tokenizer.tokenize("<")
  end

  def test_greater_than
    assert_equal [[:BAREWORD, ">"]], @tokenizer.tokenize(">")
  end

  def test_equal
    assert_equal [[:BAREWORD, "="]], @tokenizer.tokenize("=")
  end

  def test_at
    assert_equal [[:BAREWORD, "@"]], @tokenizer.tokenize("@")
  end

  def test_unassigned_bareword
    assert_equal [[:UNASSIGNED_BAREWORD, "abc"]], @tokenizer.tokenize("'abc")
  end

  def test_start_comment
    assert_equal [[:START_COMMENT, "/*"]], @tokenizer.tokenize("/*")
  end

  def test_end_comment
    assert_equal [[:END_COMMENT, "*/"]], @tokenizer.tokenize("*/")
  end
end
