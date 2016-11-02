module JSONApi
  module Response
    class Middleware < Faraday::Middleware

      def initialize(app, directory:)
        super(app)
        @directory = directory
      end

      def call(request_env)
        @app.call(request_env).on_complete do |response_env|
          response_env[:body] = JSONApi::Wrapper.wrap!(response_env, directory)
        end
      end

      def directory
        @directory || JSONApi::Response::TypeDirectory.new
      end

    end
  end
end