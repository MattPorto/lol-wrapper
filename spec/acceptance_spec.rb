require "spec_helper"
require "lol"
require "awesome_print"

# Requires connection
describe "Live API", remote: true do
  before(:all) do
    VCR.configure do |c|
      c.allow_http_connections_when_no_cassette = true
    end
  end

  let!(:api_key)  { ENV['RIOT_GAMES_API_KEY'] }
  let(:client)   { Lol::Client.new api_key }

  describe "stats" do
    it "platform data" do
      stats_keys = %w[id name locales maintenances incidents]

      result = client.lol_status.platform_data

      expect(result.raw.keys).to eq(stats_keys)
    end
  end

  describe "summoner" do
    let(:summoner_name) { "foo" }
    it "find summoner by name" do
      summoner = client.summoner.find_by_name(summoner_name)
      expect(summoner.name).to eq(summoner_name)
    end

    let(:summoner) { client.summoner.find_by_name(summoner_name) }

    it "find summoner by id" do
      response = client.summoner.find(summoner.id)
      expect(response.id).to eq(summoner.id)
    end

    it "find summoner by account id" do
      response = client.summoner.find_by_account_id(summoner.account_id)
      expect(response.id).to eq(summoner.id)
    end
  end

  describe "champion" do
    # FIXME: 403 with api key
    it "works on the collection" do
      expect { client.champion.all }.not_to raise_error
    end

    it "works on the single champion" do
      expect {client.champion.get(:id => champions.first.id)}.not_to raise_error
    end
  end

  describe "game" do

    it "works on recent games for a summoner" do
      expect {fallback.game.recent intinig.id}.not_to raise_error
    end
  end

  describe "league" do
    it "works with get" do
      expect {client.league.get intinig.id}.not_to raise_error
    end

    it "works with entries" do
      expect {fallback.league.get_entries intinig.id}.not_to raise_error
    end

    it "works with teams" do
      expect {fallback.league.by_team team.id}.not_to raise_error
    end
  end

  describe "lol-static-data" do
    pending
  end

  describe "match" do
    pending
  end

  describe "matchhistory" do
    pending
  end

  describe "team" do
    pending
  end
end
