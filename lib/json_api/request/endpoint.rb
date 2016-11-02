module JSONApi
  module Request
    class Endpoint

      attr_reader :verb
      def initialize(verb:, pattern:, options: {})
        @verb = verb
        @options = options
        @pattern = Mustermann::Expander.new(pattern, @options)
      end

      def call(connection, params)
        connection.send(@verb, path(params))
      end

      def path(params = {})
        @pattern.expand(params)
      end

    end
  end
end