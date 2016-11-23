require 'support/member'
require 'support/member/venue'
require 'spec_helper'

describe JSONApi::Response::Object do

  let(:directory)       { JSONApi::Response::TypeDirectory.new }
  let(:type)            { Member }
  let(:id)              { '1' }
  let(:name)            { 'Johnny Testman' }
  let(:venue_id)        { '123' }
  let(:venue_name)      { 'Shoreditch House' }
  let(:payload) do
    {
      type: 'members',
      id:   id,
      attributes: {
        id:   id,
        name: name,
      },
      relationships: {
        venue: {
          data: [
            {
              type: 'member/venues',
              id:   venue_id,
              attributes: {
                id: venue_id,
                name: venue_name,
              }
            }
          ]
        }
      }
    }
  end

  before do
    directory.register! Member
    directory.register! Member::Venue, type: 'member/venues'
  end

  subject { JSONApi::Response::Object.build(payload, directory) }

  it { expect(subject.id).to eql(id) }
  it { expect(subject.name).to eql(name) }

  it { expect(subject.respond_to?(:venue)).to be_truthy }
  it { expect(subject.respond_to?(:missing_key)).to be_falsey}

  it { expect(subject.venue.first.id).to eql(venue_id) }

end
