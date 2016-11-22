module JSONApi
  module Request
    class Route

      delegate :[], to: :routes

      attr_reader :fragment
      def initialize(name: nil, fragment: nil, **options, &block)
        @name     = name
        @options  = options.reverse_merge(default_options)
        @fragment = Mustermann::Expander.new(fragment, mustermann_options) if name
        instance_exec self, &block if block_given?
      end

      def new_class
        @options[:new]
      end

      def route(name, fragment, **options, &block)
        routes[name.to_sym] = self.class.new(name: name, fragment: fragment, **options, &block)
      end

      def arguments
        fragment ? fragment.patterns.first.names.map(&:to_sym) : []
      end

      def routes
        @routes ||= {}
      end

      private

        def mustermann_options
          @options.slice(:type, :additional_values)
        end

        def default_options
          {
            new: nil,
            type: :rails,
            additional_values: :append
          }
        end

    end
  end
end
