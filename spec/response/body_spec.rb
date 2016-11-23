require 'support/member'
require 'spec_helper'

RSpec.describe JSONApi::Response::Body do

  let(:response_object) { Member }
  let(:directory)       { JSONApi::Response::TypeDirectory.new }
  let(:id)              { '1' }
  let(:name)            { 'Johnny Testman' }
  let(:member_hash) do
    {
      type: 'members',
      id:   id,
      attributes: {
        name: name
      }
    }
  end

  subject { JSONApi::Response::Body.new(payload, directory) }

  before do
    directory.register! response_object
  end

  context 'Single object' do
    let(:payload) do
      {
        links: {
          self: '/members'
        },
        data: member_hash
      }
    end

    it 'should have links' do
      expect(subject.links).to_not be_nil
    end

    it 'should be a singular object' do
      expect(subject.object?).to be_truthy
    end

    it 'should automatically cast the member to a member' do
      expect(subject).to be_instance_of(response_object)
    end

    it { expect(subject.name).to eql(name) }
    it { expect(subject.id).to eql(id) }

  end

  context 'Multiple objects' do
    let(:payload) do
      {
        links: {
          self: '/members'
        },
        data: 3.times.map { member_hash }
      }
    end
    let(:member) { subject.first }

    it 'should be an array' do
      expect(subject).to be_instance_of(Array)
    end

    it 'should be a collection' do
      expect(subject.collection?).to be_truthy
    end

    it 'should automatically cast the member to a member' do
      expect(member).to be_instance_of(response_object)
    end

    it { expect(member.name).to eql(name) }
    it { expect(member.id).to eql(id) }

  end

end
