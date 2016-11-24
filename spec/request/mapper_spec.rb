require 'faraday'
require 'json_api/request/mapper'
require 'support/member'

RSpec.describe JSONApi::Request::Mapper do

  let(:stubs)      { Faraday::Adapter::Test::Stubs.new }
  let(:connection) { Faraday.new { |builder| builder.adapter(:test, stubs) } }

  let(:member_id)     { '1' }
  let(:attachment_id) { '2' }

  let(:status)        { 200 }
  let(:headers)       { {} }
  let(:response)      { {}.to_json }
  let(:uri)           { '/' }

  subject do
    JSONApi::Request::Mapper.new(connection) do
      route :members, 'members', new: Member do
        route :id, ':id' do
          route :attachments, 'attachments' do
            route :id, ':id'
          end
        end
      end
    end
  end

  describe 'respond_to?' do
    it 'is true when the method is available' do
      expect(subject.respond_to?('members')).to be_truthy
    end

    it 'is false when the method is unavailble' do
      expect(subject.respond_to?('blah')).to be_falsey
    end
  end

  context 'calling arbitrary methods' do
    it 'returns a new instance with a narrowed scope' do
      expect(subject.members).not_to eq(subject)
    end

    it 'raises an exception when the method is unavailable' do
      expect { subject.blah }.to raise_exception(NoMethodError)
    end
  end

  context 'Creating' do
    it 'Should create a member object for the correct scope' do
      expect(subject.members.new).to be_instance_of Member
    end

    context 'With attributes' do
      let(:uri) { '/members' }
      before do
        stubs.post(uri) { |env| [status, headers, env.body]}
      end

      it 'Should persist the object to the API' do
        expect(subject.members.new(id: 10, name: 'Dave Smith').save)
      end
    end
  end

  context 'Querying' do
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

        context "With extra params" do
          let(:uri) { "/members/#{member_id}?type=test" }
          it 'should execute against the correct URI' do
            expect(['/',subject.members.id(member_id, type: 'test').to_url].join).to eql(uri)
          end
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
end
