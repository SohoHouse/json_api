module JSONApi
  module Request
    class Mapper

      def initialize(connection, **options, &block)
        @connection = connection
        @options    = options.reverse_merge(default_options)
        instance_exec self, &block if block_given?
      end

      def get(*args)
        route(:get, *args)
      end

      def post(*args)
        route(:post, *args)
      end

      def scope(name, &block)
        scope = self.class.new(@connection, **@options) do |mapper|
          instance_exec mapper, &block if block_given?
        end
        endpoints[name.to_sym] = scope
      end

      def endpoints
        @endpoints ||= {}
      end

      def method_missing(method, *args, **kwargs, &block)
        if endpoints.keys.include?(method)
          if endpoints[method].is_a? JSONApi::Request::Endpoint
            params = {id: args.first}.merge(kwargs)
            endpoints[method].call(@connection, params).body
          else
            endpoints[method]
          end
        else
          super
        end
      end

      private

        def route(verb, name, pattern)
          endpoints[name.to_sym] = JSONApi::Request::Endpoint.new(verb: verb, pattern: pattern, options: @options) 
        end

        def default_options
          {
            type: :rails,
            additional_values: :append
          }
        end

    end
  end
end