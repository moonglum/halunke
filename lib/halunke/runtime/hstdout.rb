module Halunke
  module Runtime
    HStdout = HClass.new(
      "Stdout",
      [],
      {
        "puts" => HFunction.new([:self, :str], lambda { |context|
          puts context["str"].ruby_value
          context["str"]
        })
      },
      {},
      true
    )
  end
end
