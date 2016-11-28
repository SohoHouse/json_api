require 'faraday'
require 'json_api/response/type_directory'
require 'json_api/response/wrapper'

module JSONApi
  module Response
    class Middleware < Faraday::Middleware

      attr_reader :directory

      def initialize(app, directory: JSONApi::Response::TypeDirectory.new)
        super(app)
        @directory = directory
      end

      def call(request_env)
        @app.call(request_env).on_complete do |response_env|
          response_env[:body] = JSONApi::Response::Wrapper.wrap!(response_env, directory)
        end
      end

    end
  end
end
