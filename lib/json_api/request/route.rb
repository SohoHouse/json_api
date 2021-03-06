require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/module/delegation'
require 'mustermann'
require 'mustermann/rails'

module JSONApi
  module Request
    class Route

      delegate :key?, :fetch, to: :routes

      attr_reader :fragment, :routes

      def initialize(name: nil, fragment: nil, **options, &block)
        @name     = name
        @options  = default_options.merge(options)
        @fragment = Mustermann::Expander.new(fragment, mustermann_options) if name
        @routes   = {}
        instance_exec self, &block if block_given?
      end

      def new_class
        @options.fetch(:new)
      end

      def route(name, fragment, **options, &block)
        routes[name.to_sym] =
          self.class.new(name: name, fragment: fragment, **options, &block)
      end

      def arguments
        fragment ? fragment.patterns.first.names.map(&:to_sym) : []
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
