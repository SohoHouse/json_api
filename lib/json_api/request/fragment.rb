require 'active_support/core_ext/object/blank'

module JSONApi
  module Request
    class Fragment

      attr_reader :route, :arguments

      def initialize(route, args, kwargs)
        @route    = route
        @arguments = kwargs.merge({
          route.arguments.first => args.first
        }).reject { |k, v| k.blank? || v.blank? }
      end

      def call
        route.fragment.expand(arguments)
      end

    end
  end
end
