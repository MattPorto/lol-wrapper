require "spec_helper"
require "lol"

include Lol

describe LolStatusRequest do
  subject { LolStatusRequest.new "api_key", "euw" }

  it 'inherits from Request' do
    expect(LolStatusRequest).to be < Request
  end

  describe '#platform_data' do
    let(:response) { subject.platform_data }

    before(:each) { stub_request(subject, 'lol-status-platform', 'platform-data') }

    it 'returns status' do
      expect(response).to be_a(DynamicModel)
    end

    it 'services returns an array of Services' do
      expect(response.services.map(&:class).uniq).to eq([DynamicModel])
    end
  end
end
