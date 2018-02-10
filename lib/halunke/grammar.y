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

rule
  Program:
    Expressions { result = val[0] }
  ;

  Expressions:
    /* empty */            { result = Nodes.new([]) }
  | Expression Expressions { result = Nodes.new([val[0]].concat(val[1].nodes)) }
  ;

  Expression:
    NUMBER                                                 { result = NumberNode.new(val[0]) }
  | STRING                                                 { result = StringNode.new(val[0]) }
  | BAREWORD                                               { result = BarewordNode.new(val[0]) }
  | UNASSIGNED_BAREWORD                                    { result = UnassignedNode.new(BarewordNode.new(val[0])) }
  | START_COMMENT Expressions END_COMMENT                  { result = Nodes.new([]) }
  | OPEN_CURLY Expressions CLOSE_CURLY                     { result = FunctionNode.new(ArrayNode.new([]), val[1]) }
  | OPEN_CURLY BAR Expressions BAR Expressions CLOSE_CURLY { result = FunctionNode.new(val[2].to_array, val[4]) }
  | OPEN_PAREN Expression Expressions CLOSE_PAREN          { result = MessageSendNode.new(val[1], val[2].to_message) }
  | OPEN_BRACKET Expressions CLOSE_BRACKET                 { result = val[1].to_array }
  | OPEN_DICT_BRACKET Expressions CLOSE_BRACKET            { result = val[1].to_dictionary }
  ;
end

---- header

require "halunke/lexer"
require "halunke/nodes"

---- inner

def parse(code)
  @tokens = Lexer.new.tokenize(code)
  do_parse
end

def next_token
  @tokens.shift
end
