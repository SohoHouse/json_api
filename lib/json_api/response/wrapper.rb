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
          JSONApi::Response::Body.new(body, directory)
        else
          body
        end
      end

      def body
        @body ||= (parsable_json? ? JSON.parse(response[:body]) : response[:body]).with_indifferent_access
      end

      def json?
        request_headers.key?("Content-Type") && request_headers["Content-Type"].include?("json") 
      end

      def parsable_json?
        json? && response[:body].is_a?(String)
      end

      def request_headers
        response[:request_headers]
      end
    end
  end
end