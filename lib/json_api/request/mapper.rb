module JSONApi
  module Request
    class Mapper

      attr_reader :connection
      def initialize(connection, &block)
        @connection = connection
        @root       = JSONApi::Request::Route.new(&block)
      end

      def method_missing(method, *args, **kwargs, &block)
        if @root[method.to_sym]
          JSONApi::Request::Builder.new(connection).tap do |x|
            x.capture @root[method.to_sym], args, kwargs
          end
        else
          super
        end
      end

    end
  end
end