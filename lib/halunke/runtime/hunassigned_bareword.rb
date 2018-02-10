module Halunke
  module Runtime
    HUnassignedBareword = HClass.new(
      "UnassignedBareword",
      [],
      {
        "=" => HFunction.new([:self, :other], lambda { |context|
          context.parent[context["self"].ruby_value] = context["other"]
          context["true"]
        }),
        "inspect" => HFunction.new([:self], lambda { |context|
          HString.create_instance("'#{context["self"].ruby_value}")
        })
      },
      {},
      true
    )
  end
end
