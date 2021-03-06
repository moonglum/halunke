module Halunke
  module Runtime
    HArray = HClass.new(
      "Array",
      [],
      {
        "@ else" => HFunction.new([:self, :index, :fallback], lambda { |context|
          context["self"].ruby_value[context["index"].ruby_value] || context["fallback"]
        }),
        "=" => HFunction.new([:self, :other], lambda { |context|
          return context["false"] if context["self"].ruby_value.length != context["other"].ruby_value.length

          context["self"].ruby_value.zip(context["other"].ruby_value).map do |a, b|
            a.receive_message(context.parent, "=", [b])
          end.reduce(context["true"]) do |memo, value|
            memo.receive_message(context, "and", [value])
          end
        }),
        "map" => HFunction.new([:self, :fn], lambda { |context|
          return HArray.create_instance(context["self"].ruby_value.map do |x|
            context["fn"].receive_message(context, "call", [HArray.create_instance([x])])
          end)
        }),
        "reduce with" => HFunction.new([:self, :fn, :initial], lambda { |context|
          context["self"].ruby_value.reduce(context["initial"]) do |memo, current|
            context["fn"].receive_message(context, "call", [HArray.create_instance([memo, current])])
          end
        }),
        "find else" => HFunction.new([:self, :search_fn, :fallback], lambda { |context|
          context["self"].ruby_value.find(-> { context["fallback"] }) do |element|
            context["search_fn"].receive_message(context, "call", [HArray.create_instance([element])]) == context["true"]
          end
        }),
        "to_boolean" => HFunction.new([:self], lambda { |context|
          context["true"]
        }),
        "to_string" => HFunction.new([:self], lambda { |context|
          inspected_members = context["self"].ruby_value.map do |member|
            member.receive_message(context, "to_string", []).ruby_value
          end
          HString.create_instance("#{inspected_members.join("\n")}")
        }),
        "inspect" => HFunction.new([:self], lambda { |context|
          inspected_members = context["self"].ruby_value.map { |member| member.inspect(context) }
          HString.create_instance("[#{inspected_members.join(' ')}]")
        })
      },
      {},
      true
    )
  end
end
