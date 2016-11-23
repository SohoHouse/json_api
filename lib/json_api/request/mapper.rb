module JSONApi
  module Request
    class Mapper

      attr_reader :connection
      def initialize(connection, &block)
        @connection = connection
        @root       = JSONApi::Request::Route.new(&block)
      end

      def method_missing(method, *args, **kwargs, &block)
        if respond_to?(method)
          JSONApi::Request::Builder.new(connection).tap do |x|
            x.capture @root.fetch(method.to_sym), args, kwargs
          end
        else
          super
        end
      end

      def respond_to?(method)
        @root.key?(method.to_sym)
      end

    end
  end
end
