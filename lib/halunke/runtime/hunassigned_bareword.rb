module Halunke
  module Runtime
    HUnassignedBareword = HClass.new(
      "UnassignedBareword",
      [],
      {
        "=" => HFunction.new([:self, :other], lambda { |context|
          bareword_name = context["self"].ruby_value

          begin
            context.parent[bareword_name] = context["other"]
          rescue
            assigned_value = context.parent[context["self"].ruby_value].inspect(context)
            raise HBarewordAlreadyAssigned.new("Bareword '#{bareword_name} is already assigned to #{assigned_value}. In Halunke, you can only assign once.", context["self"].source_code_position)
          end
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
