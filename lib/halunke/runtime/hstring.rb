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
        "match" => HFunction.new([:self, :regexp], lambda { |context|
          match_data = context["self"].ruby_value.match(context["regexp"].ruby_value)
          h = {}
          unless match_data.nil?
            match_data.named_captures.each_pair do |key, value|
              h[HString.create_instance(key)] = HString.create_instance(value)
            end
            match_data.to_a.each_with_index do |value, key|
              h[HString.create_instance(key)] = HString.create_instance(value)
            end
          end
          HDictionary.create_instance(h)
        }),
        "scan" => HFunction.new([:self, :regexp], lambda { |context|
          result = context["self"].ruby_value.scan(context["regexp"].ruby_value)

          HArray.create_instance(result.map do |r|
            if r.class == Array
              HArray.create_instance(r.map { |x| HString.create_instance(x) })
            else
              HString.create_instance(r)
            end
          end)
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
        "to_boolean" => HFunction.new([:self], lambda { |context|
          context["true"]
        }),
        "to_string" => HFunction.new([:self], lambda { |context|
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
