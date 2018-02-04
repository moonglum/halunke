require "test_helper"
require "halunke/interpreter"

class InterpreterTest < Minitest::Test
  def setup
    @interpreter = Halunke::Interpreter.new
  end

  def test_adding_two_numbers
    assert_equal 9, @interpreter.eval("(7 + 2)")
  end

  def test_reverse_string
    assert_equal "eknulah", @interpreter.eval('("halunke" reverse)')
  end

  def test_inner_message_send
    assert_equal 8, @interpreter.eval("(4 + (2 + 2))")
  end

  def test_replace_with_on_string
    assert_equal "bhb", @interpreter.eval('("aha" replace "a" with "b")')
  end
end
