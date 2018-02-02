require "test_helper"

class NodesTest < Minitest::Test
  def test_number_node_eval
    number_node = Halunke::NumberNode.new(7)
    context = { Number: FakeClass.new }

    assert_equal 7, number_node.eval(context)
  end

  def test_string_node_eval
    string_node = Halunke::StringNode.new("test")
    context = { String: FakeClass.new }

    assert_equal "test", string_node.eval(context)
  end

  def test_nodes
    context = Object.new
    node1 = Minitest::Mock.new
    node1.expect :eval, 1, [context]
    node2 = Minitest::Mock.new
    node2.expect :eval, 2, [context]
    nodes = Halunke::Nodes.new([node1, node2])

    assert_equal 2, nodes.eval(context)
    node1.verify
    node2.verify
  end

  def test_message_send
    context = Object.new
    message = Object.new
    message_node = Minitest::Mock.new
    message_node.expect :eval, [message], [context]
    receiver = Minitest::Mock.new
    receiver.expect :receive_message, :result, [message]
    receiver_node = Minitest::Mock.new
    receiver_node.expect :eval, receiver, [context]
    node = Halunke::MessageSendNode.new(receiver_node, message_node)

    assert_equal :result, node.eval(context)
  end

  def test_message_with_no_args
    context = Object.new
    a = Minitest::Mock.new
    a.expect :value, :a, []
    node = Halunke::MessageNode.new([a])

    assert_equal [:a, []], node.eval(context)
  end

  def test_message_with_one_arg
    context = Object.new
    a = Minitest::Mock.new
    a.expect :value, :a, []
    b = Minitest::Mock.new
    b.expect :eval, :b, [context]
    node = Halunke::MessageNode.new([a, b])

    assert_equal [:a, [:b]], node.eval(context)
  end

  private

  class FakeClass
    def create_instance(arg)
      arg
    end
  end
end
