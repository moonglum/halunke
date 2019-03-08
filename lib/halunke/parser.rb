#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.15
# from Racc grammer file "".
#

require 'racc/parser.rb'


require "halunke/tokenizer"
require "halunke/nodes"

module Halunke
  class Parser < Racc::Parser

module_eval(<<'...end grammar.y/module_eval...', 'grammar.y', 54)

def parse(code)
  @tokens = Tokenizer.new.tokenize(code)
  do_parse
end

def next_token
  @tokens.shift
end
...end grammar.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
     4,     5,     6,    10,    13,     9,    16,     7,    11,    21,
    12,    22,     8,     4,     5,     6,    10,    25,     9,    26,
     7,    11,    27,    12,    28,     8,     4,     5,     6,    10,
    29,     9,   nil,     7,    11,   nil,    12,   nil,     8,     4,
     5,     6,    10,   nil,     9,   nil,     7,    11,   nil,    12,
   nil,     8,     4,     5,     6,    10,   nil,     9,   nil,     7,
    11,   nil,    12,   nil,     8,     4,     5,     6,    10,   nil,
     9,   nil,     7,    11,   nil,    12,   nil,     8,     4,     5,
     6,    10,   nil,     9,   nil,     7,    11,   nil,    12,   nil,
     8,     4,     5,     6,    10,   nil,     9,   nil,     7,    11,
   nil,    12,   nil,     8 ]

racc_action_check = [
     0,     0,     0,     0,     1,     0,     9,     0,     0,    13,
     0,    15,     0,     3,     3,     3,     3,    18,     3,    19,
     3,     3,    20,     3,    23,     3,     8,     8,     8,     8,
    24,     8,   nil,     8,     8,   nil,     8,   nil,     8,    10,
    10,    10,    10,   nil,    10,   nil,    10,    10,   nil,    10,
   nil,    10,    11,    11,    11,    11,   nil,    11,   nil,    11,
    11,   nil,    11,   nil,    11,    12,    12,    12,    12,   nil,
    12,   nil,    12,    12,   nil,    12,   nil,    12,    16,    16,
    16,    16,   nil,    16,   nil,    16,    16,   nil,    16,   nil,
    16,    17,    17,    17,    17,   nil,    17,   nil,    17,    17,
   nil,    17,   nil,    17 ]

racc_action_pointer = [
    -2,     4,   nil,    11,   nil,   nil,   nil,   nil,    24,    -7,
    37,    50,    63,     9,   nil,    -4,    76,    89,    11,     8,
    11,   nil,   nil,    11,    22,   nil,   nil,   nil,   nil,   nil ]

racc_action_default = [
    -2,   -15,    -1,    -2,    -6,    -7,    -8,    -9,    -2,    -4,
    -2,    -2,    -2,   -15,    -3,   -15,    -2,    -2,   -15,   -15,
   -15,    30,   -10,   -15,   -15,   -12,   -13,   -14,    -5,   -11 ]

racc_goto_table = [
     2,     1,    17,    14,   nil,   nil,   nil,   nil,    15,   nil,
    18,    19,    20,   nil,   nil,   nil,    23,    24 ]

racc_goto_check = [
     2,     1,     4,     2,   nil,   nil,   nil,   nil,     2,   nil,
     2,     2,     2,   nil,   nil,   nil,     2,     2 ]

racc_goto_pointer = [
   nil,     1,     0,   nil,    -7 ]

racc_goto_default = [
   nil,   nil,   nil,     3,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 17, :_reduce_1,
  0, 18, :_reduce_2,
  2, 18, :_reduce_3,
  0, 20, :_reduce_4,
  3, 20, :_reduce_5,
  1, 19, :_reduce_6,
  1, 19, :_reduce_7,
  1, 19, :_reduce_8,
  1, 19, :_reduce_9,
  3, 19, :_reduce_10,
  4, 19, :_reduce_11,
  3, 19, :_reduce_12,
  3, 19, :_reduce_13,
  3, 19, :_reduce_14 ]

racc_reduce_n = 15

racc_shift_n = 30

racc_token_table = {
  false => 0,
  :error => 1,
  :NUMBER => 2,
  :STRING => 3,
  :BAREWORD => 4,
  :OPEN_PAREN => 5,
  :CLOSE_PAREN => 6,
  :OPEN_CURLY => 7,
  :CLOSE_CURLY => 8,
  :UNASSIGNED_BAREWORD => 9,
  :OPEN_BRACKET => 10,
  :CLOSE_BRACKET => 11,
  :OPEN_DICT_BRACKET => 12,
  :BAR => 13,
  :START_COMMENT => 14,
  :END_COMMENT => 15 }

racc_nt_base = 16

racc_use_result_var = false

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "NUMBER",
  "STRING",
  "BAREWORD",
  "OPEN_PAREN",
  "CLOSE_PAREN",
  "OPEN_CURLY",
  "CLOSE_CURLY",
  "UNASSIGNED_BAREWORD",
  "OPEN_BRACKET",
  "CLOSE_BRACKET",
  "OPEN_DICT_BRACKET",
  "BAR",
  "START_COMMENT",
  "END_COMMENT",
  "$start",
  "Program",
  "Expressions",
  "Expression",
  "Arguments" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'grammar.y', 21)
  def _reduce_1(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 25)
  def _reduce_2(val, _values)
     Nodes.new([]) 
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 26)
  def _reduce_3(val, _values)
     Nodes.new([val[0]].concat(val[1].nodes)) 
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 30)
  def _reduce_4(val, _values)
     ArrayNode.new([]) 
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 31)
  def _reduce_5(val, _values)
     ArrayNode.new(val[1].nodes, val[0][1], val[2][2]) 
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 35)
  def _reduce_6(val, _values)
     NumberNode.new(*val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 36)
  def _reduce_7(val, _values)
     StringNode.new(*val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 37)
  def _reduce_8(val, _values)
     BarewordNode.new(*val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 38)
  def _reduce_9(val, _values)
     UnassignedNode.new(BarewordNode.new(*val[0]), val[0][1], val[0][2]) 
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 39)
  def _reduce_10(val, _values)
     Nodes.new([]) 
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 40)
  def _reduce_11(val, _values)
     FunctionNode.new(val[1], val[2], val[0][1], val[3][2]) 
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 41)
  def _reduce_12(val, _values)
     MessageSendNode.new(val[1].nodes, val[0][1], val[2][2]) 
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 42)
  def _reduce_13(val, _values)
     ArrayNode.new(val[1].nodes, val[0][1], val[2][2]) 
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 43)
  def _reduce_14(val, _values)
     DictionaryNode.new(val[1].nodes, val[0][1], val[2][2]) 
  end
.,.,

def _reduce_none(val, _values)
  val[0]
end

  end   # class Parser
  end   # module Halunke
