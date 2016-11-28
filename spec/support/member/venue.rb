require 'json_api/model'

class Member
  class Venue < JSONApi::Model

    attribute :id,   String
    attribute :name, String

  end
end
