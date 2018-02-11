module Halunke
  module Runtime
    HStdio = HClass.new(
      "Stdio",
      [],
      {
        "puts" => HFunction.new([:self, :obj], lambda { |context|
          str = context["obj"].receive_message(context, "to_s", [])
          puts str.ruby_value
          str
        }),
        "p" => HFunction.new([:self, :obj], lambda { |context|
          str = context["obj"].receive_message(context, "inspect", [])
          puts str.ruby_value
          context["obj"]
        })
      },
      {},
      true
    )
  end
end
