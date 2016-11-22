module JSONApi
  module Response
    class TypeDirectory

      delegate :[], to: :directory

      attr_reader :directory
      def initialize
        @directory = {}.with_indifferent_access
      end

      def register!(object, type: nil)
        key = (type || object.to_s.demodulize.pluralize.underscore.to_sym)
        @directory[key] = object
      end

    end
  end
end
