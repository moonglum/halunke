=begin
%%{
  machine lexer;

  number = ('+'|'-')?[0-9]+;
  string = '"' [^"]* '"';
  bareword = [a-zA-Z_]+;
  open_paren = '(';
  close_paren = ')';
  operator = '+' | '-' | '<' | '>';

  main := |*

    number => { emit(:NUMBER, data[ts...te].to_i) };
    string => { emit(:STRING, data[ts+1...te-1]) };
    bareword => { emit(:BAREWORD, data[ts...te]) };
    open_paren => { emit(:OPEN_PAREN, data[ts...te]) };
    close_paren => { emit(:CLOSE_PAREN, data[ts...te]) };
    operator => { emit(:OPERATOR, data[ts ... te]) };
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

    def emit(type, value)
      @tokens << [ type, value ]
    end
  end
end
