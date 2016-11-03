module JSONApi
  module Request
    class Endpoint

      attr_reader :verb
      def initialize(verb:, pattern:, options: {})
        @verb = verb
        @options = options
        @pattern = Mustermann::Expander.new(pattern, @options)
      end

      def call(connection, params={})
        payload = params.delete(:payload)
        connection.send(@verb, path(params), payload)
      end

      def path(params = {})
        @pattern.expand(params)
      end

    end
  end
end