class Halunke::Parser

token NUMBER
token STRING
token BAREWORD
token OPEN_PAREN
token CLOSE_PAREN
token OPEN_CURLY
token CLOSE_CURLY
token UNASSIGNED_BAREWORD
token OPEN_BRACKET
token CLOSE_BRACKET
token OPEN_DICT_BRACKET
token BAR
token START_COMMENT
token END_COMMENT

options no_result_var

rule
  Program:
    Expressions { val[0] }
  ;

  Expressions:
    /* empty */            { Nodes.new([]) }
  | Expression Expressions { Nodes.new([val[0]].concat(val[1].nodes)) }
  ;

  Arguments:
    /* empty */         { ArrayNode.new([]) }
  | BAR Expressions BAR { ArrayNode.new(val[1].nodes, val[0][1], val[2][2]) }
  ;

  Expression:
    NUMBER                                                 { NumberNode.new(*val[0]) }
  | STRING                                                 { StringNode.new(*val[0]) }
  | BAREWORD                                               { BarewordNode.new(*val[0]) }
  | UNASSIGNED_BAREWORD                                    { UnassignedNode.new(BarewordNode.new(*val[0]), val[0][1], val[0][2]) }
  | START_COMMENT Expressions END_COMMENT                  { Nodes.new([]) }
  | OPEN_CURLY Arguments Expressions CLOSE_CURLY           { FunctionNode.new(val[1], val[2], val[0][1], val[3][2]) }
  | OPEN_PAREN Expressions CLOSE_PAREN                     { MessageSendNode.new(val[1].nodes, val[0][1], val[2][2]) }
  | OPEN_BRACKET Expressions CLOSE_BRACKET                 { ArrayNode.new(val[1].nodes, val[0][1], val[2][2]) }
  | OPEN_DICT_BRACKET Expressions CLOSE_BRACKET            { DictionaryNode.new(val[1].nodes, val[0][1], val[2][2]) }
  ;
end

---- header

require "halunke/tokenizer"
require "halunke/nodes"

---- inner

def parse(code)
  @tokens = Tokenizer.new.tokenize(code)
  do_parse
end

def next_token
  @tokens.shift
end
