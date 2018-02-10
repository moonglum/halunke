require "halunke/lexer"

class LexerTest < Minitest::Test
  def setup
    @lexer = Halunke::Lexer.new
  end

  def test_number
    assert_equal [[:NUMBER, 82r]], @lexer.tokenize("82")
  end

  def test_negative_number
    assert_equal [[:NUMBER, -82r]], @lexer.tokenize("-82")
  end

  def test_rational_number
    assert_equal [[:NUMBER, 0.9r]], @lexer.tokenize("0.9")
  end

  def test_string
    assert_equal [[:STRING, "82"]], @lexer.tokenize('"82"')
  end

  def test_identifier
    assert_equal [[:BAREWORD, "name"]], @lexer.tokenize("name")
  end

  def test_open_parenthesis
    assert_equal [[:OPEN_PAREN, "("]], @lexer.tokenize("(")
  end

  def test_closing_parenthesis
    assert_equal [[:CLOSE_PAREN, ")"]], @lexer.tokenize(")")
  end

  def test_open_curly
    assert_equal [[:OPEN_CURLY, "{"]], @lexer.tokenize("{")
  end

  def test_closing_curly
    assert_equal [[:CLOSE_CURLY, "}"]], @lexer.tokenize("}")
  end

  def test_open_bracket
    assert_equal [[:OPEN_BRACKET, "["]], @lexer.tokenize("[")
  end

  def test_closing_bracket
    assert_equal [[:CLOSE_BRACKET, "]"]], @lexer.tokenize("]")
  end

  def test_open_dict_bracket
    assert_equal [[:OPEN_DICT_BRACKET, "@["]], @lexer.tokenize("@[")
  end

  def test_bar
    assert_equal [[:BAR, "|"]], @lexer.tokenize("|")
  end

  def test_plus
    assert_equal [[:BAREWORD, "+"]], @lexer.tokenize("+")
  end

  def test_minus
    assert_equal [[:BAREWORD, "-"]], @lexer.tokenize("-")
  end

  def test_less_than
    assert_equal [[:BAREWORD, "<"]], @lexer.tokenize("<")
  end

  def test_greater_than
    assert_equal [[:BAREWORD, ">"]], @lexer.tokenize(">")
  end

  def test_equal
    assert_equal [[:BAREWORD, "="]], @lexer.tokenize("=")
  end

  def test_at
    assert_equal [[:BAREWORD, "@"]], @lexer.tokenize("@")
  end

  def test_unassigned_bareword
    assert_equal [[:UNASSIGNED_BAREWORD, "abc"]], @lexer.tokenize("'abc")
  end

  def test_start_comment
    assert_equal [[:START_COMMENT, "/*"]], @lexer.tokenize("/*")
  end

  def test_end_comment
    assert_equal [[:END_COMMENT, "*/"]], @lexer.tokenize("*/")
  end
end
