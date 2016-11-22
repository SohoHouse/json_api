module JSONApi
  module Request
    class Builder

      attr_reader :fragments

      def initialize(connection)
        @connection = connection
        @fragments = []
      end

      def capture(route, *args, **kwargs)
        fragments << JSONApi::Request::Fragment.new(route, args, kwargs)
      end

      def new(**args)
        raise NoMethodError unless current_route && current_route.new_class
        JSONApi::Request::Object.new(current_route.new_class.new(args), self)
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
        if current_route && current_route.key?(method)
          capture(current_route.fetch(method), *args, kwargs, &block)
          self
        else
          super
        end
      end

      def to_url
        fragments.map(&:call).compact.join('/')
      end

      private

        def current_route
          fragments.last.route if fragments.last
        end

    end
  end
end
