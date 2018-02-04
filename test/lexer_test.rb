require "halunke/lexer"

class LexerTest < Minitest::Test
  def setup
    @lexer = Halunke::Lexer.new
  end

  def test_number
    assert_equal [[:NUMBER, 82]], @lexer.tokenize("82")
  end

  def test_negative_number
    assert_equal [[:NUMBER, -82]], @lexer.tokenize("-82")
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

  def test_plus
    assert_equal [[:OPERATOR, "+"]], @lexer.tokenize("+")
  end

  def test_minus
    assert_equal [[:OPERATOR, "-"]], @lexer.tokenize("-")
  end

  def test_less_than
    assert_equal [[:OPERATOR, "<"]], @lexer.tokenize("<")
  end

  def test_greater_than
    assert_equal [[:OPERATOR, ">"]], @lexer.tokenize(">")
  end
end
