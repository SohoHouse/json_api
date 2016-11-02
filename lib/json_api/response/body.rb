module JSONApi
  module Response 
    class Body < SimpleDelegator

    def initialize(payload, directory)
      @payload   = payload
      @directory = directory
      super(build_data!)
    end

    def links
      @payload[:links]
    end

    def collection?
      @payload[:data].is_a?(Array)
    end

    def object?
      @payload[:data].is_a?(Hash)
    end

    private

      def build_data!
        objects = [@payload[:data]].flatten.map do |payload| 
          JSONApi::Object.build(payload, @directory)
        end
        return objects.first if object?
        objects
      end

  end
end