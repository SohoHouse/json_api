module JSONApi
  module Request
    class Object < SimpleDelegator

      delegate :class, :is_a?, :instance_of?, to: :__getobj__

      attr_reader :builder
      def initialize(object, builder)
        @builder = builder
        super(object)
      end

      def save
        builder.post(attributes)
      end

    end
  end
end
