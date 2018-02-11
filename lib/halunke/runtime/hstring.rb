module Halunke
  module Runtime
    HString = HClass.new(
      "String",
      [],
      {
        "reverse" => HFunction.new([:self], lambda { |context|
          HString.create_instance(context["self"].ruby_value.reverse)
        }),
        "replace with" => HFunction.new([:self, :searchword, :replacement], lambda { |context|
          result = context["self"].ruby_value.gsub(
            context["searchword"].ruby_value,
            context["replacement"].ruby_value
          )
          HString.create_instance(result)
        }),
        "=" => HFunction.new([:self, :other], lambda { |context|
          if context["self"].ruby_value == context["other"].ruby_value
            context["true"]
          else
            context["false"]
          end
        }),
        "+" => HFunction.new([:self, :other], lambda { |context|
          HString.create_instance(context["self"].ruby_value + context["other"].ruby_value)
        }),
        "to_s" => HFunction.new([:self], lambda { |context|
          context["self"]
        }),
        "inspect" => HFunction.new([:self], lambda { |context|
          HString.create_instance(context["self"].ruby_value.inspect)
        })
      },
      {},
      true
    )
  end
end
