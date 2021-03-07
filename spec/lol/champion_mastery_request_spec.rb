require 'spec_helper'
require 'lol'
include Lol

describe ChampionMasteryRequest do
  subject { ChampionMasteryRequest.new('api_key', 'euw') }
  let(:dummy_encrypted_summoner_id) { 'qHn0uNkpA1T-NqQ0zHTEqNh1BhH5SAsGWwkZsacbeKBqSdkUEaYOcYNjDomm60vMrLWHu4ulYg1C5Q' }

  it 'check inherit' do
    expect(ChampionMasteryRequest.ancestors[1]).to eq Request
  end

  it 'total score' do
    stub_request_raw subject, 60, "scores/by-summoner/#{dummy_encrypted_summoner_id}"
    expect(subject.total_score dummy_encrypted_summoner_id).to eq 60
  end

  it 'find' do
    url = "champion-masteries/by-summoner/#{dummy_encrypted_summoner_id}/by-champion/40"
    stub_request subject, 'champion-mastery', url

    result = subject.find 40, dummy_encrypted_summoner_id

    expect(result).to be_a DynamicModel
    expect(result.highest_grade).to eq 'S+'
    expect(result.champion_points).to eq 34356
    expect(result.summoner_id).to eq 1
    expect(result.champion_points_until_next_level).to be_zero
    expect(result.chest_granted).to be_truthy
    expect(result.champion_level).to eq 5
    expect(result.tokens_earned).to eq 2
    expect(result.champion_id).to eq 40
    expect(result.champion_points_since_last_level).to eq 12756
  end

  it 'all' do
    fixture = load_fixture('champion-masteries', described_class.api_version)
    url = "champion-masteries/by-summoner/#{dummy_encrypted_summoner_id}"
    stub_request subject, 'champion-masteries', url

    result = subject.all dummy_encrypted_summoner_id

    expect(result).to be_a Array
    expect(result.map(&:class).uniq).to eq [DynamicModel]
    expect(result.count).to eq fixture.count
  end
end
