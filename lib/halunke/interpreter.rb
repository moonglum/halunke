require "halunke/parser"

module Halunke
  class Interpreter
    attr_reader :root_context

    def initialize
      @parser = Parser.new
      @root_context = HContext.root_context(self)
      self.eval(self.prelude)
    end

    def eval(str)
      nodes = @parser.parse(str)
      nodes.eval(root_context).inspect(root_context)
    end

    def prelude
      <<~PROGRAM
          (Class new 'True
            attributes []
            methods @[
              "and" { |'self 'other|
                other
              }
              "or" { |'self 'other|
                self
              }
              "then else" { |'self 'true_branch 'false_branch|
                (true_branch call [])
              }
              "inspect" { |'self 'other|
                "true"
              }
            ]
          )

          ('true = (True new))

          (Class new 'False
            attributes []
            methods @[
              "and" { |'self 'other|
                self
              }
              "or" { |'self 'other|
                other
              }
              "then else" { |'self 'true_branch 'false_branch|
                (false_branch call [])
              }
              "inspect" { |'self 'other|
                "false"
              }
            ]
          )

          ('false = (False new))
      PROGRAM
    end
  end
end
