module JSONApi
  class Model
    include Comparable
    include Virtus.model
    include Virtus.relations

    def <=>(other)
      to_s <=> other.to_s
    end

  end
end
