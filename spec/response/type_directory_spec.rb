require 'support/member'
require 'spec_helper'

describe JSONApi::Response::TypeDirectory do

  let(:type) { Member }

  subject { JSONApi::Response::TypeDirectory.new }

  context 'Without custom key' do
    before do
      subject.register! Member
    end

    it 'should return the class for the :members key' do
      expect(subject[:members]).to eql(type)
    end
  end

  context 'With custom key' do
    before do
      subject.register! Member, type: :users
    end

    it { expect(subject[:users]).to eql(type) }
  end

end