require 'json_api/request/fragment_collection'
require 'json_api/request/object'

module JSONApi
  module Request
    class Builder

      attr_reader :fragments

      def initialize(connection)
        @connection = connection
        @fragments = FragmentCollection.new
      end

      delegate :capture, :to_url, to: :@fragments

      def new(**kwargs)
        JSONApi::Request::Object.new(current_route.new_class.new(kwargs), self)
      end

      def get
        @connection.get(to_url).body
      end

      def post(payload)
        @connection.post(to_url, payload).body
      end

      def delete
        @connection.delete(to_url).body
      end

      def put(payload)
        @connection.put(to_url, payload).body
      end

      def method_missing(method, *args, **kwargs, &block)
        if respond_to?(method)
          capture(current_route.fetch(method), *args, kwargs, &block)
          self
        else
          super
        end
      end

      def respond_to_missing?(method, *)
        current_route && current_route.key?(method)
      end

      private

        def current_route
          fragments.last_fragment_route
        end
    end
  end
end
