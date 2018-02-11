module Halunke
  module Runtime
    HNumber = HClass.new(
      "Number",
      [],
      {
        "+" => HFunction.new([:self, :other], lambda { |context|
          HNumber.create_instance(context["self"].ruby_value + context["other"].ruby_value)
        }),
        "-" => HFunction.new([:self, :other], lambda { |context|
          HNumber.create_instance(context["self"].ruby_value - context["other"].ruby_value)
        }),
        "/" => HFunction.new([:self, :other], lambda { |context|
          HNumber.create_instance(context["self"].ruby_value / context["other"].ruby_value)
        }),
        "*" => HFunction.new([:self, :other], lambda { |context|
          HNumber.create_instance(context["self"].ruby_value * context["other"].ruby_value)
        }),
        "<" => HFunction.new([:self, :other], lambda { |context|
          if context["self"].ruby_value < context["other"].ruby_value
            context["true"]
          else
            context["false"]
          end
        }),
        ">" => HFunction.new([:self, :other], lambda { |context|
          if context["self"].ruby_value > context["other"].ruby_value
            context["true"]
          else
            context["false"]
          end
        }),
        "=" => HFunction.new([:self, :other], lambda { |context|
          if context["self"].ruby_value == context["other"].ruby_value
            context["true"]
          else
            context["false"]
          end
        }),
        "to_s" => HFunction.new([:self], lambda { |context|
          float_value = context["self"].ruby_value.to_f
          float_value = float_value.to_i if float_value.to_i == float_value
          HString.create_instance(float_value.to_s)
        }),
        "inspect" => HFunction.new([:self], lambda { |context|
          context["self"].receive_message(context, "to_s", [])
        })
      },
      {},
      true
    )
  end
end
