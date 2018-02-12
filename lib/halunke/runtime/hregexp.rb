module Halunke
  module Runtime
    HRegexp = HClass.new(
      "Regexp",
      [],
      {
        "to_b" => HFunction.new([:self], lambda { |context|
          context["true"]
        }),
        "to_s" => HFunction.new([:self], lambda { |context|
          HString.create_instance(context["self"].ruby_value.inspect)
        }),
        "inspect" => HFunction.new([:self], lambda { |context|
          HString.create_instance(context["self"].ruby_value.inspect)
        })
      },
      {
        "new" => HFunction.new([:self, :attr], lambda { |context|
          str = (context["attr"].ruby_value.find do |key, _value|
            key.ruby_value == "string"
          end)[1].ruby_value

          HRegexp.create_instance(Regexp.new(str))
        }),
        "from" => HFunction.new([:self, :str], lambda { |context|
          context["self"].receive_message(
            context,
            "new",
            [HDictionary.create_instance(HString.create_instance("string") => context["str"])]
          )
        })
      },
      true
    )
  end
end
