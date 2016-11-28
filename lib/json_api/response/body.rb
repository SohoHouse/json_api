require 'active_support/core_ext/module/delegation'
require 'json_api/response/object'

module JSONApi
  module Response
    class Body < SimpleDelegator

    delegate :class, :is_a?, :instance_of?, to: :__getobj__

    attr_reader :builder
    def initialize(payload, directory, builder=nil)
      @payload   = payload
      @directory = directory
      super(build_data!)
    end

    def links
      @payload.fetch(:links)
    end

    def data
      @payload.fetch(:data, {})
    end

    def collection?
      data.is_a?(Array)
    end

    def object?
      data.is_a?(Hash)
    end

    private

      def build_data!
        objects = [data].flatten.map do |body|
          JSONApi::Response::Object.build(body, @directory)
        end
        object? ? objects.first : objects
      end

    end
  end
end
