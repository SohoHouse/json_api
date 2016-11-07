module JSONApi
  module Response
    class Object < SimpleDelegator
      class << self

        def build(payload, directory)
          type       = directory[payload[:type]]
          id         = id
          attributes = (payload[:attributes] || {}).merge({id: payload[:id]})
          metadata   = payload.except(:type, :id, :attributes)
          return new(payload, {}) if type.blank?
          new(type.new(attributes), metadata)
        end

      end

      delegate :class, :is_a?, :instance_of?, to: :__getobj__

      def initialize(object, metadata)
        super(object)
        @metadata = metadata
      end

    end
  end
end