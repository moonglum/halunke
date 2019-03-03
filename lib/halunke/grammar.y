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

  Expression:
    NUMBER                                                 { NumberNode.new(val[0]) }
  | STRING                                                 { StringNode.new(val[0]) }
  | BAREWORD                                               { BarewordNode.new(val[0]) }
  | UNASSIGNED_BAREWORD                                    { UnassignedNode.new(BarewordNode.new(val[0])) }
  | START_COMMENT Expressions END_COMMENT                  { Nodes.new([]) }
  | OPEN_CURLY Expressions CLOSE_CURLY                     { FunctionNode.new(ArrayNode.new([]), val[1]) }
  | OPEN_CURLY BAR Expressions BAR Expressions CLOSE_CURLY { FunctionNode.new(val[2].to_array, val[4]) }
  | OPEN_PAREN Expression Expressions CLOSE_PAREN          { MessageSendNode.new(val[1], val[2].to_message) }
  | OPEN_BRACKET Expressions CLOSE_BRACKET                 { val[1].to_array }
  | OPEN_DICT_BRACKET Expressions CLOSE_BRACKET            { val[1].to_dictionary }
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
