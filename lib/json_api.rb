require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'

require 'mustermann'
require 'mustermann/rails'
require 'virtus'
require 'virtus/relations'

require "json_api/version"

require "json_api/request"
require "json_api/response"
require 'json_api/model'

module JSONApi
  module_function

  def response
    JSONApi::Response
  end

  def request
    JSONApi::Request
  end

end
