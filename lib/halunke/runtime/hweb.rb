module Halunke
  module Runtime
    HWeb = HClass.new(
      "Web",
      [],
      {
        "run on" => HFunction.new([:self, :app, :host_port], lambda { |context|
          require "rack"

          host, port = context["host_port"].ruby_value.split(":")

          # TODO: Body, Headers
          Rack::Handler::WEBrick.run(lambda { |env|
            henv = context["Dictionary"].create_instance(
              context["String"].create_instance("request_method") => context["String"].create_instance(env["REQUEST_METHOD"]),
              context["String"].create_instance("path") => context["String"].create_instance(env["PATH_INFO"]),
              context["String"].create_instance("query") => context["String"].create_instance(env["QUERY_STRING"])
            )
            result = context["app"].receive_message(context, "call", [henv]).ruby_value

            status = result[0].ruby_value

            headers = {}
            result[1].ruby_value.each_pair do |key, value|
              headers[key.ruby_value] = value.ruby_value
            end

            body = result[2].ruby_value.map(&:ruby_value)

            [status, headers, body]
          }, { Host: host, Port: port })

          env["host_port"]
        })
      },
      {},
      true
    )
  end
end
