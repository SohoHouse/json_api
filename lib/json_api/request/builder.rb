module JSONApi
  module Request
    class Builder

      def initialize(connection)
        @connection = connection
      end

      def capture(route, *args, **kwargs)
        fragments << JSONApi::Request::Fragment.new(route, args, kwargs)
      end

      def fragments
        @fragments ||= []
      end

      def new
        current_route.build(connection)
      end

      def get
        @connection.get(to_url).body
      end

      def method_missing(method, *args, **kwargs, &block)
        if current_route && current_route[method]
          capture(current_route[method], args, kwargs, &block)
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