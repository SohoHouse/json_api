require 'virtus'

class Member
  include Virtus.model

  attribute :id,   String
  attribute :name, String
end
