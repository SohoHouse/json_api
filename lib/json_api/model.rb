module JSONApi
  class Model
    include Comparable
    include Virtus.model
    include Virtus.relations

    def <=>(other)
      to_s <=> other.to_s
    end

    def initialize(args)
      @client = args.delete(:client) if args[:client]
      super(args)
    end

    def client
      @client.blank? ? parent.client : @client
    end

  end
end