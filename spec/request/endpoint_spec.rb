require 'spec_helper'

describe JSONApi::Request::Endpoint do

  let(:stubs)      { Faraday::Adapter::Test::Stubs.new }
  let(:connection) { Faraday.new {|builder| builder.adapter(:test, stubs)} }

  let(:verb)       { :get }
  let(:status)     { 200 }
  let(:headers)    { {} }
  let(:response)   { {}.to_json }
  let(:pattern)    { '/test' }
  let(:uri)        { pattern }

  subject { JSONApi::Request::Endpoint.new(verb: verb, pattern: pattern) }

  before do
    stubs.send(verb, uri) { |env| [status, headers, response ] }
  end

  context 'GET requests' do
    let(:uri)  { pattern }

    context 'No parameters' do
      let(:pattern) { '/test' }

      it 'should be successful' do
        expect(subject.call(connection).success?).to be_truthy
      end
    end

    context 'With parameters' do
      let(:pattern) { '/test/:id' }
      let(:id)      { 100 }
      let(:uri)     { "/test/#{id}" }

      it 'should be successful' do
        expect(subject.call(connection, id: id).success?).to be_truthy
      end
    end
  end

  context 'POST requests' do
    let(:verb) { :post }
    let(:payload) { { name: 'Jan Mustermann' } }

    context 'No parameters' do
      it 'should be successful' do
        expect(subject.call(connection, payload: payload).success?).to be_truthy
      end
    end

    context 'With parameters' do
      let(:pattern) { '/test/:id' }
      let(:id)      { 100 }
      let(:uri)     { "/test/#{id}" } 

      it 'should be successful' do
        expect(subject.call(connection, id: id, payload: payload).success?).to be_truthy
      end
    end
  end

  

end