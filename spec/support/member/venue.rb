require 'virtus'

class Member
  class Venue
    include Virtus.model

    attribute :id,   String
    attribute :name, String
  end
end
