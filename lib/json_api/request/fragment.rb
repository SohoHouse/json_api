module JSONApi
  module Request
    class Fragment

      attr_reader :route
      def initialize(route, args, kwargs)
        @route    = route
        @args     = args
        @kwargs   = kwargs
      end

      def primary_argument
        route.fragment.arguments.first
      end

      def arguments
        @arguments ||= @kwargs.merge({
          route.arguments.first => @args.first
        }).reject {|k, v| k.blank? || v.blank? }
      end

      def call
        route.fragment.expand(arguments)
      end

    end
  end
end