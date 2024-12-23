require "spec_helper"
require "lol"

include Lol

describe MatchRequest do
  subject { MatchRequest.new "api_key", "euw" }

  it "inherits from Request" do
    expect(MatchRequest).to be < Request
  end

  describe "#find" do
    it "returns a DynamicModel" do
      stub_request subject, 'match', "matches/1"
      expect(subject.find 1).to be_a DynamicModel
    end
  end

  describe "#find_timeline" do
    it "returns a DynamicModel" do
      stub_request subject, 'timeline', "timelines/by-match/1"
      expect(subject.find_timeline 1).to be_a DynamicModel
    end
  end

  describe "#ids_by_tournament_code" do
    it "returns a list of ids" do
      stub_request subject, 'ids-by-tc', "matches/by-tournament-code/1/ids"
      result = subject.ids_by_tournament_code '1'
      expect(result).to be_a Array
      expect(result.map(&:class).uniq).to eq [Integer]
    end
  end

  describe "#find_by_tournament" do
    it "returns a DynamicModel" do
      stub_request subject, 'match-with-tc', "matches/1/by-tournament-code/2"
      expect(subject.find_by_tournament 1, 2).to be_a DynamicModel
    end
  end

  describe "#all" do
    it "returns a DynamicModel" do
      stub_request subject, 'matches', "matchlists/by-account/1"
      expect(subject.all 1).to be_a DynamicModel
    end
  end

  describe "#recent" do
    it "returns a DynamicModel" do
      stub_request subject, 'matches-recent', "matchlists/by-account/1"
      expect(subject.recent 1).to be_a DynamicModel
    end
  end
end
