require 'json_api/response/body'
require 'json_api/response/type_directory'
require 'json_api/response/wrapper'
require 'support/member'

RSpec.describe JSONApi::Response::Wrapper do

  let(:type)            { Member }
  let(:directory)       { JSONApi::Response::TypeDirectory.new }

  let(:body)             { {}.to_json }
  let(:response_headers) { { 'Content-Type' => 'application/json' } }
  let(:response)         { { body: body, response_headers: response_headers } }

  before do
    directory.register! Member
  end

  context 'wrapping the response' do
    subject { JSONApi::Response::Wrapper.wrap!(response, directory) }

    context 'with a parsable json object' do
      it 'should wrap and return a JSONApi::Response::Body' do
        expect(subject).to be_a JSONApi::Response::Body
      end
    end

    context 'without a parsable json object' do
      let(:body)            { 'test string' }
      let(:response_headers) { { 'Content-Type' => 'text/plain' } }

      it 'should do nothing' do
        expect(subject).to eql(body)
      end
    end

  end

end
