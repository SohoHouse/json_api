module JSONApi
  module Request
    class FragmentCollection
      def initialize
        @collection = []
      end

      def capture(route, *args, **kwargs)
        @collection << Fragment.new(route, args, kwargs)
      end

      def last_fragment_route
        @collection.last && @collection.last.route
      end

      def to_url
        @collection.map(&:call).compact.join('/')
      end
    end
  end
end
