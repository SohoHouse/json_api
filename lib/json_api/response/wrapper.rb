module JSONApi
  module Response
    class Wrapper
      class << self
        def wrap!(response, directory)
          new(response, directory).wrapped_object
        end
      end

      attr_reader :response, :directory
      def initialize(response, directory)
        @response  = response
        @directory = directory
      end

      def wrapped_object
        if parsable_json?
          JSONApi::Response::Body.new(body.with_indifferent_access, directory)
        else
          body
        end
      end

      def body
        @body ||= (parsable_json? ? JSON.parse(response[:body]) : response[:body])
      end

      def json?
        response_headers.key?("Content-Type") && response_headers["Content-Type"].include?("json")
      end

      def parsable_json?
        json? && response[:body].is_a?(String)
      end

      def response_headers
        response[:response_headers]
      end
    end
  end
end
