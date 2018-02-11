=begin
%%{
  machine lexer;

  number = ('+'|'-')?[0-9]+('.'[0-9]+)?;
  string = '"' [^"]* '"';
  unassigned_bareword = "'" [a-zA-Z_]+;
  bareword = [a-zA-Z_]+ | '+' | '-' | '*' | '/' | '<' | '>' | '=' | '@';
  open_paren = '(';
  close_paren = ')';
  open_curly = '{';
  close_curly = '}';
  open_bracket = '[';
  close_bracket = ']';
  open_dict_bracket = '@[';
  start_comment = '/*';
  end_comment = '*/';
  bar = "|";

  main := |*

    number => { emit(:NUMBER, data[ts...te].to_r, ts, te) };
    string => { emit(:STRING, data[ts+1...te-1], ts, te) };
    unassigned_bareword => { emit(:UNASSIGNED_BAREWORD, data[ts+1 ...te], ts, te) };
    bareword => { emit(:BAREWORD, data[ts...te], ts, te) };
    open_paren => { emit(:OPEN_PAREN, data[ts...te], ts, te) };
    close_paren => { emit(:CLOSE_PAREN, data[ts...te], ts, te) };
    open_curly => { emit(:OPEN_CURLY, data[ts...te], ts, te) };
    close_curly => { emit(:CLOSE_CURLY, data[ts...te], ts, te) };
    open_bracket => { emit(:OPEN_BRACKET, data[ts...te], ts, te) };
    close_bracket => { emit(:CLOSE_BRACKET, data[ts...te], ts, te) };
    open_dict_bracket => { emit(:OPEN_DICT_BRACKET, data[ts...te], ts, te) };
    start_comment => { emit(:START_COMMENT, data[ts...te], ts, te) };
    end_comment => { emit(:END_COMMENT, data[ts...te], ts, te) };
    bar => { emit(:BAR, data[ts...te], ts, te) };
    space;
    any => { raise "Could not lex '#{ data[ts...te] }'" };

  *|;
}%%
=end

module Halunke
  class Lexer
    def initialize
      %% write data;
      @tokens = []
    end

    def tokenize(data)
      data.chomp!
      eof = data.length

      %% write init;
      %% write exec;

      @tokens
    end

    private

    def emit(type, value, ts, te)
      @tokens << [ type, [value, ts, te] ]
    end
  end
end
