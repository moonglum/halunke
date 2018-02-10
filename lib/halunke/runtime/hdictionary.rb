module Halunke
  module Runtime
    HDictionary = HClass.new(
      "Dictionary",
      [],
      {
        "inspect" => HFunction.new([:self], lambda { |context|
          x = []
          context["self"].ruby_value.each_pair do |key, value|
            x.push(key.inspect(context))
            x.push(value.inspect(context))
          end
          HString.create_instance("@[#{x.join(' ')}]")
        }),
        "@ else" => HFunction.new([:self, :search, :fallback], lambda { |context|
          result = context["self"].ruby_value.find do |key, _value|
            key.receive_message(context, "=", [context["search"]]).inspect(context) == "true"
          end
          result ? result[1] : context["fallback"]
        })
      },
      {},
      true
    )
  end
end
