require 'spec_helper'

describe JSONApi::Request::Mapper do

  let(:stubs)      { Faraday::Adapter::Test::Stubs.new }
  let(:connection) { Faraday.new {|builder| builder.adapter(:test, stubs)} }

  let(:member_id)     { '1' }
  let(:attachment_id) { '2' }

  let(:status)        { 200 }
  let(:headers)       { {} }
  let(:response)      { {}.to_json }
  let(:uri)           { '/' }
  
  subject do
    JSONApi::Request::Mapper.new(connection) do
      route :members, 'members' do
        route :id, ':id' do
          route :attachments, 'attachments' do
            route :id, ':id'
          end
        end
      end
    end
  end

  before do
    stubs.get(uri) { |env| [status, headers, response ] }
  end

  context "Members top level scope" do

    context "All" do
      let(:uri) { '/members' }
      it 'should be able to return all members' do
        expect(subject.members.get).to eql(response)
      end
    end

    context "Find" do
      let(:uri) { "/members/#{member_id}" }
      it 'should find the member with the first argument cast as an id' do
        expect(subject.members.id(member_id).get).to eql(response)
      end
    end

    context "Attachments scope" do

      context "All" do
        let(:uri) { "/members/#{member_id}/attachments" }
        it 'should correctly accept the params to build the url' do
          expect(subject.members.id(member_id).attachments.get).to eql(response)
        end
      end

      context "Find" do
        let(:uri) { "/members/#{member_id}/attachments/#{attachment_id}" }
        it 'should return an attachment id' do
          expect(subject.members.id(member_id).attachments.id(attachment_id).get).to eql(response)
        end
      end

    end

  end

end