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
