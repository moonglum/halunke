require "test_helper"
require "halunke/interpreter"

class NodesTest < Minitest::Test
  def setup
    interpreter = Halunke::Interpreter.new
    @context = interpreter.root_context
  end

  def test_number_node_eval
    number_node = Halunke::NumberNode.new(7)

    assert_equal '7', number_node.eval(@context).inspect(@context)
  end

  def test_string_node_eval
    string_node = Halunke::StringNode.new("test")

    assert_equal '"test"', string_node.eval(@context).inspect(@context)
  end

  def test_array
    node = Halunke::ArrayNode.new([
      Halunke::NumberNode.new(2),
      Halunke::NumberNode.new(8)
    ])

    assert_equal '[2 8]', node.eval(@context).inspect(@context)
  end

  def test_dictionary
    node = Halunke::DictionaryNode.new([
      Halunke::StringNode.new("a"),
      Halunke::NumberNode.new(1),
      Halunke::StringNode.new("b"),
      Halunke::NumberNode.new(2)
    ])

    assert_equal '@["a" 1 "b" 2]', node.eval(@context).inspect(@context)
  end

  def test_bareword_node_eval
    @context["test"] = @context["Number"].create_instance(1)
    bareword_node = Halunke::BarewordNode.new("test")

    assert_equal '1', bareword_node.eval(@context).inspect(@context)
  end

  def test_nodes
    node1 = Halunke::NumberNode.new(1)
    node2 = Halunke::NumberNode.new(2)
    nodes = Halunke::Nodes.new([node1, node2])

    assert_equal '2', nodes.eval(@context).inspect(@context)
  end

  def test_message_send_with_no_args
    receiver = Minitest::Mock.new
    receiver.expect :receive_message, :result, [@context, "aaa", [], any_keyword_arguments]
    receiver_node = Minitest::Mock.new
    receiver_node.expect :eval, receiver, [@context]
    node = Halunke::MessageSendNode.new(receiver_node, [
      Halunke::BarewordNode.new("aaa")
    ])

    assert_equal :result, node.eval(@context)
  end

  def test_message_send_with_only_a_number
    expected_arguments = array_matching(
      native_object_matching(5)
    )
    receiver = Minitest::Mock.new
    receiver.expect :receive_message, :result, [@context, "+", expected_arguments, any_keyword_arguments]
    receiver_node = Minitest::Mock.new
    receiver_node.expect :eval, receiver, [@context]
    node = Halunke::MessageSendNode.new(receiver_node, [
      Halunke::NumberNode.new(5)
    ])

    assert_equal :result, node.eval(@context)
  end

  def test_message_send_with_one_argument
    expected_arguments = array_matching(
      native_object_matching(5)
    )
    receiver = Minitest::Mock.new
    receiver.expect :receive_message, :result, [@context, "-", expected_arguments, any_keyword_arguments]
    receiver_node = Minitest::Mock.new
    receiver_node.expect :eval, receiver, [@context]
    node = Halunke::MessageSendNode.new(receiver_node, [
      Halunke::BarewordNode.new("-"),
      Halunke::NumberNode.new(5)
    ])

    assert_equal :result, node.eval(@context)
  end

  def test_message_send_with_two_arguments
    expected_arguments = array_matching(
      native_object_matching(5),
      native_object_matching(6)
    )
    receiver = Minitest::Mock.new
    receiver.expect :receive_message, :result, [@context, "a b", expected_arguments, any_keyword_arguments]
    receiver_node = Minitest::Mock.new
    receiver_node.expect :eval, receiver, [@context]
    node = Halunke::MessageSendNode.new(receiver_node, [
      Halunke::BarewordNode.new("a"),
      Halunke::NumberNode.new(5),
      Halunke::BarewordNode.new("b"),
      Halunke::NumberNode.new(6)
    ])

    assert_equal :result, node.eval(@context)
  end


  def test_function_node
    node = Halunke::FunctionNode.new(
      Halunke::ArrayNode.new([]),
      Halunke::Nodes.new([
        Halunke::NumberNode.new(1)
      ])
    )

    assert_equal '1', node.eval(@context).receive_message(@context, "call", [Halunke::Runtime::HArray.create_instance([])]).inspect(@context)
  end

  def test_unassigend_bareword
    unassigned_bareword = Minitest::Mock.new
    unassigned_bareword.expect :create_instance, nil, ["abc", any_keyword_arguments]
    context = { "UnassignedBareword" => unassigned_bareword }

    node = Halunke::UnassignedNode.new(
      Halunke::BarewordNode.new("abc")
    )

    node.eval(context)
    unassigned_bareword.verify
  end

  private

  def any_keyword_arguments
    Hash # Since Minitest::Mock will perform a === on each argument
  end
end
