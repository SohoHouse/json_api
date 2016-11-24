module JSONApi
  module Response
    class Object < SimpleDelegator
      class << self

        def build(payload, directory)
          type       = directory[payload[:type]]
          id         = id
          attributes = (payload[:attributes] || {}).merge({id: payload[:id]})
          metadata   = payload.except(:type, :id, :attributes)
          return new(payload, metadata: {}, directory: directory) if type.blank?
          new(type.new(attributes), metadata: metadata, directory: directory)
        end

      end

      delegate :class, :is_a?, :instance_of?, to: :__getobj__

      def initialize(object, metadata:, directory:)
        super(object)
        @metadata  = metadata
        @directory = directory
      end

      def save
        builder.put(attributes)
      end

      def method_missing(method, *args, &block)
        if relationships.key? method
          relationships[method]
        else
          super
        end
      end

      def respond_to_missing?(method, *)
        relationships.key?(method) || super
      end

      def relationships
        return {} if @metadata[:relationships].blank?
        @relationships ||= @metadata[:relationships].each.with_object({}) do |(key, value), hash|
          hash[key.to_sym] = JSONApi::Response::Body.new(value, @directory, nil)
        end
      end

    end
  end
end
