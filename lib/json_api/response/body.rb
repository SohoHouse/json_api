module JSONApi
  module Response 
    class Body < SimpleDelegator

    delegate :class, :is_a?, :instance_of?, to: :__getobj__

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
          JSONApi::Response::Object.build(payload, @directory)
        end
        return objects.first if object?
        objects
      end

    end
  end
end