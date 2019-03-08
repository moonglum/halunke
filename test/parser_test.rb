require "test_helper"
require "halunke/parser"

class ParserTest < Minitest::Test
  def setup
    @parser = Halunke::Parser.new
  end

  def test_number
    expected_nodes = Halunke::Nodes.new([
      Halunke::NumberNode.new(1)
    ])

    assert_equal expected_nodes, @parser.parse("1")
  end

  def test_string
    expected_nodes = Halunke::Nodes.new([
      Halunke::StringNode.new("Hello World")
    ])

    assert_equal expected_nodes, @parser.parse('"Hello World"')
  end

  def test_bareword
    expected_nodes = Halunke::Nodes.new([
      Halunke::BarewordNode.new("fizz")
    ])

    assert_equal expected_nodes, @parser.parse("fizz")
  end

  def test_unassigned
    expected_nodes = Halunke::Nodes.new([
      Halunke::UnassignedNode.new(
        Halunke::BarewordNode.new("abc")
      )
    ])

    assert_equal expected_nodes, @parser.parse("'abc")
  end

  def test_message_with_no_args
    expected_nodes = Halunke::Nodes.new([
      Halunke::MessageSendNode.new([
        Halunke::NumberNode.new(2),
        Halunke::BarewordNode.new("a")
      ])
    ])

    assert_equal expected_nodes, @parser.parse("(2 a)")
  end

  def test_message_with_one_arg
    expected_nodes = Halunke::Nodes.new([
      Halunke::MessageSendNode.new([
        Halunke::NumberNode.new(2),
        Halunke::BarewordNode.new("+"),
        Halunke::NumberNode.new(3)
      ])
    ])

    assert_equal expected_nodes, @parser.parse("(2 + 3)")
  end

  def test_message_with_two_args
    expected_nodes = Halunke::Nodes.new([
      Halunke::MessageSendNode.new([
        Halunke::NumberNode.new(2),
        Halunke::BarewordNode.new("a"),
        Halunke::BarewordNode.new("x"),
        Halunke::BarewordNode.new("b"),
        Halunke::NumberNode.new(4)
      ])
    ])

    assert_equal expected_nodes, @parser.parse("(2 a x b 4)")
  end

  def test_inner_message_send
    expected_nodes = Halunke::Nodes.new([
      Halunke::MessageSendNode.new([
        Halunke::NumberNode.new(2),
        Halunke::BarewordNode.new("a"),
        Halunke::MessageSendNode.new([
          Halunke::NumberNode.new(1),
          Halunke::BarewordNode.new("x")
        ])
      ])
    ])

    assert_equal expected_nodes, @parser.parse("(2 a (1 x))")
  end

  def test_function_with_no_params
    expected_nodes = Halunke::Nodes.new([
      Halunke::FunctionNode.new(
        Halunke::ArrayNode.new([]),
        Halunke::Nodes.new([
          Halunke::NumberNode.new(1)
        ])
      )
    ])

    assert_equal expected_nodes, @parser.parse("{ 1 }")
  end

  def test_function_with_params
    expected_nodes = Halunke::Nodes.new([
      Halunke::FunctionNode.new(
        Halunke::ArrayNode.new([
          Halunke::UnassignedNode.new(Halunke::BarewordNode.new("a")),
          Halunke::UnassignedNode.new(Halunke::BarewordNode.new("b"))
        ]),
        Halunke::Nodes.new([
          Halunke::NumberNode.new(1)
        ])
      )
    ])

    assert_equal expected_nodes, @parser.parse("{ |'a 'b| 1 }")
  end

  def test_array
    expected_nodes = Halunke::Nodes.new([
      Halunke::ArrayNode.new([
        Halunke::NumberNode.new(2),
        Halunke::NumberNode.new(3)
      ])
    ])

    assert_equal expected_nodes, @parser.parse("[2 3]")
  end

  def test_dictionary
    expected_nodes = Halunke::Nodes.new([
      Halunke::DictionaryNode.new([
        Halunke::StringNode.new("a"),
        Halunke::NumberNode.new(1),
        Halunke::StringNode.new("b"),
        Halunke::NumberNode.new(2)
      ])
    ])

    assert_equal expected_nodes, @parser.parse('@["a" 1 "b" 2]')
  end

  def test_comment
    expected_nodes = Halunke::Nodes.new([
      Halunke::Nodes.new([])
    ])

    assert_equal expected_nodes, @parser.parse('/* hallo */')
  end

  def test_token_position
    skip "Redo this after the refactoring is done"
    outer_message_send = @parser.parse("(20 a (1 x))").nodes.first
    assert_equal 0, outer_message_send.ts
    assert_equal 11, outer_message_send.te

    receiver = outer_message_send.receiver
    assert_equal 1, receiver.ts
    assert_equal 2, receiver.te

    a = outer_message_send.message.first.first
    assert_equal 4, a.ts
    assert_equal 4, a.te

    inner_message_send = outer_message_send.message.first.last
    assert_equal 6, inner_message_send.ts
    assert_equal 10, inner_message_send.te
  end
end
