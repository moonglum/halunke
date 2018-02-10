require "test_helper"
require "halunke/interpreter"

class InterpreterTest < Minitest::Test
  def setup
    @interpreter = Halunke::Interpreter.new
  end

  def test_adding_two_numbers
    assert_equal '9', @interpreter.eval("(7 + 2)")
  end

  def test_reverse_string
    assert_equal '"eknulah"', @interpreter.eval('("halunke" reverse)')
  end

  def test_double_reverse_string
    assert_equal '"halunke"', @interpreter.eval('(("halunke" reverse) reverse)')
  end

  def test_comment
    assert_equal '2', @interpreter.eval('/* Comment */ 2')
  end

  def test_inner_message_send
    assert_equal '8', @interpreter.eval("(4 + (2 + 2))")
  end

  def test_rational_numbers
    assert_equal '0.9', @interpreter.eval("((0.3 + 0.3) + 0.3)")
  end

  def test_function
    assert_equal '#<Function (2)>', @interpreter.eval("{ |'a 'b| (a + b) }")
  end

  def test_class
    assert_equal "#<Class Number>", @interpreter.eval("Number")
  end

  def test_unassigned_bareword
    assert_equal "'xyz", @interpreter.eval("'xyz")
  end

  def test_replace_with_on_string
    assert_equal '"bhb"', @interpreter.eval('("aha" replace "a" with "b")')
  end

  def test_true
    assert_equal 'true', @interpreter.eval("true")
  end

  def test_false
    assert_equal 'false', @interpreter.eval("false")
  end

  def test_true_comparison
    assert_equal 'true', @interpreter.eval('(2 < 3)')
  end

  def test_false_comparison
    assert_equal 'false', @interpreter.eval('(2 > 3)')
  end

  def test_and
    assert_equal 'true', @interpreter.eval('(true and (4 > 1))')
    assert_equal 'false', @interpreter.eval('(true and (4 < 1))')
    assert_equal 'false', @interpreter.eval('(false and (4 > 1))')
    assert_equal 'false', @interpreter.eval('(false and (4 < 1))')
  end

  def test_or
    assert_equal 'true', @interpreter.eval('(true or (4 > 1))')
    assert_equal 'true', @interpreter.eval('(true or (4 < 1))')
    assert_equal 'true', @interpreter.eval('(false or (4 > 1))')
    assert_equal 'false', @interpreter.eval('(false or (4 < 1))')
  end

  def test_then_else
    assert_equal '"foo"', @interpreter.eval('(true then { "foo" } else { "bar" })')
    assert_equal '"bar"', @interpreter.eval('(false then { "foo" } else { "bar" })')
  end

  def test_equality
    assert_equal 'true', @interpreter.eval('(1 = 1)')
    assert_equal 'false', @interpreter.eval('(1 = 2)')
    assert_equal 'true', @interpreter.eval('("a" = "a")')
    assert_equal 'false', @interpreter.eval('("a" = "b")')
    assert_equal 'true', @interpreter.eval('([1 "a"] = [1 "a"])')
    assert_equal 'false', @interpreter.eval('([1 "a"] = [1 "b"])')
    assert_equal 'false', @interpreter.eval('([1 "a"] = [1 "a" 2])')
  end

  def test_assign
    assert_equal "true", @interpreter.eval("('a = 2)")
    assert_equal "2", @interpreter.eval("a")
  end

  def test_no_reassignement
    @interpreter.eval("('a = 2)")
    assert_raises do
      @interpreter.eval("('a = 1)")
    end
  end

  def test_array
    assert_equal "[2 3 4]", @interpreter.eval("[2 3 4]")
  end

  def test_pattern_matching
    assert_equal "true", @interpreter.eval("(['a 2] = [1 2])")
    assert_equal "1", @interpreter.eval("a")
  end

  def test_clean_context
    assert_equal "12", @interpreter.eval("({ ('a = 12) a } call [])")
    # a should not be found
    assert_raises do
      @interpreter.eval("a")
    end
  end

  def test_use_outer_context
    assert_equal "true", @interpreter.eval("('a = 12)")
    assert_equal "12", @interpreter.eval("({ a } call [])")
  end

  def test_bug_params_leaving_context
    @interpreter.eval('("bla" reverse)')
    # self should not be found
    assert_raises do
      @interpreter.eval("self")
    end
  end

  def test_own_function_with_params
    assert_equal "0.9", @interpreter.eval("({|'a 'b| (a + b)} call [0.6 0.3])")
  end

  def test_map
    assert_equal "[1 2 3]", @interpreter.eval("([0 1 2] map { |'a| (a + 1) })")
  end

  def test_dictionary
    assert_equal '@["x" 5 "y" 2]', @interpreter.eval('@["x" 5 "y" 2]')
  end

  def test_dictionary_lookup
    assert_equal '2', @interpreter.eval('(@["x" 5 "y" 2] @ "y" else 7)')
    assert_equal '7', @interpreter.eval('(@["x" 5 "y" 2] @ "z" else 7)')
  end

  def test_counter_class
    @interpreter.eval(counter_program)
    @interpreter.eval(%{('counter = (Counter new @["value" 1 "increaseBy" 2]))})
    assert_equal '1', @interpreter.eval('(counter value)')
    assert_equal '3', @interpreter.eval('((counter increase) value)')
  end

  def test_counter_class_default_values
    @interpreter.eval(counter_program)
    @interpreter.eval(%{('counter = (Counter new))})
    assert_equal '0', @interpreter.eval('(counter value)')
  end

  def test_counter_class_with_unknown_attribute
    @interpreter.eval(counter_program)
    assert_raises do
      @interpreter.eval(%{('counter = (Counter new @["typo" 2]))})
    end
  end

  private

  def counter_program
    <<~PROGRAM
			(Class new 'Counter
				attributes ["value" "increaseBy"]
				methods @[
					"value" { |'self|
						(self @ "value" else 0)
					}
					"increase" { |'self|
						(Counter new @["value" ((self value) + (self @ "increaseBy" else 1))])
					}
				]
			)
    PROGRAM
  end
end
