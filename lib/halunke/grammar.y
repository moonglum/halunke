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
    Expressions  { result = val[0] }
  ;

  Expressions:
    /* empty */            { result = Nodes.new }
  | Expression Expressions { result = Nodes.new([val[0]]).concat(val[1]) }
  ;

  Expression:
    Literal
  | START_COMMENT Expressions END_COMMENT { result = Nodes.new }
  | OPEN_CURLY Expressions CLOSE_CURLY { result = Halunke::FunctionNode.new(Halunke::ArrayNode.new([]), val[1]) }
  | OPEN_CURLY Args Expressions CLOSE_CURLY { result = Halunke::FunctionNode.new(val[1], val[2]) }
  | OPEN_PAREN Expression Expressions CLOSE_PAREN { result = Halunke::MessageSendNode.new(val[1], MessageNode.new(val[2].nodes)) }
  | OPEN_BRACKET Expressions CLOSE_BRACKET { result = ArrayNode.new(val[1].nodes) }
  | OPEN_DICT_BRACKET Expressions CLOSE_BRACKET { result = DictionaryNode.new(val[1].nodes) }
  ;

  Args:
    BAR UnassignedBarewords BAR { result = Halunke::ArrayNode.new(val[1].nodes) }
  ;

  UnassignedBarewords:
    /* empty */        { result = Nodes.new }
  | UnassignedBareword UnassignedBarewords { result = Nodes.new([val[0]]).concat(val[1]) }
  ;

  UnassignedBareword:
    UNASSIGNED_BAREWORD { result = UnassignedNode.new(BarewordNode.new(val[0])) }
  ;

  Literal:
    NUMBER   { result = NumberNode.new(val[0]) }
  | STRING   { result = StringNode.new(val[0]) }
  | BAREWORD { result = BarewordNode.new(val[0]) }
  | UNASSIGNED_BAREWORD { result = UnassignedNode.new(BarewordNode.new(val[0])) }
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
