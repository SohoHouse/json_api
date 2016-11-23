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
        builder.post(as_json)
      end

    end
  end
end
