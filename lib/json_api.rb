require "active_support"
require "active_support/core_ext"
require 'mustermann'
require 'mustermann/rails'

require "json_api/version"

require "json_api/request"
require "json_api/response"

module JSONApi
  module_function

  def response
    JSONApi::Response
  end

  def request
    JSONApi::Request
  end

end