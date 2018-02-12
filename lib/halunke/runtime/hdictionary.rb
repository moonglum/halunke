module Halunke
  module Runtime
    HDictionary = HClass.new(
      "Dictionary",
      [],
      {
        "@ else" => HFunction.new([:self, :search, :fallback], lambda { |context|
          result = context["self"].ruby_value.find do |key, _value|
            key.receive_message(context, "=", [context["search"]]).inspect(context) == "true"
          end
          result ? result[1] : context["fallback"]
        }),
        "merge" => HFunction.new([:self, :other], lambda { |context|
          HDictionary.create_instance(context["self"].ruby_value.merge(context["other"].ruby_value))
        }),
        "to_b" => HFunction.new([:self], lambda { |context|
          context["true"]
        }),
        "to_s" => HFunction.new([:self], lambda { |context|
          x = []
          context["self"].ruby_value.each_pair do |key, value|
            key_s = key.receive_message(context, "to_s", [])
            value_s = value.receive_message(context, "to_s", [])
            x.push("#{key_s.ruby_value} #{value_s.ruby_value}")
          end
          HString.create_instance(x.join("\n"))
        }),
        "inspect" => HFunction.new([:self], lambda { |context|
          x = []
          context["self"].ruby_value.each_pair do |key, value|
            x.push(key.inspect(context))
            x.push(value.inspect(context))
          end
          HString.create_instance("@[#{x.join(' ')}]")
        })
      },
      {
        "from" => HFunction.new([:self, :array], lambda { |context|
          context["self"].create_instance(context["array"].ruby_value.map(&:ruby_value).to_h)
        })
      },
      true
    )
  end
end
