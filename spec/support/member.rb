require 'json_api/model'

class Member < JSONApi::Model

  attribute :id,   String
  attribute :name, String

end
