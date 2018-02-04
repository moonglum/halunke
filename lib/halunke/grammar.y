class Halunke::Parser

token NUMBER
token STRING
token BAREWORD
token OPEN_PAREN
token CLOSE_PAREN
token OPERATOR

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
  | OPEN_PAREN Expression Expressions CLOSE_PAREN { result = Halunke::MessageSendNode.new(val[1], MessageNode.new(val[2].nodes)) }
  ;

  Literal:
    NUMBER   { result = NumberNode.new(val[0]) }
  | STRING   { result = StringNode.new(val[0]) }
  /* TODO: Are Operators just Barewords? */
  | BAREWORD { result = BarewordNode.new(val[0]) }
  | OPERATOR { result = BarewordNode.new(val[0]) }
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
