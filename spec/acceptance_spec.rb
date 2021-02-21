require "spec_helper"
require "lol"
require "awesome_print"

# Requires connection
describe "Live API testing", remote: true do
  before(:all) do
    VCR.configure do |c|
      c.allow_http_connections_when_no_cassette = true
    end
  end

  # FIXME: returns nil value when uses environment variables
  let(:api_key)  { ENV['RIOT_GAMES_API_KEY'] || "RGAPI-48dea073-d582-4be4-9e94-faedffbb9e59" }
  let(:client)   { Lol::Client.new api_key }
  # let(:player) { client.summoner.by_name("foo").first }

  describe "stats" do
    it "works with platform data" do
      expect{ client.lol_status.platform_data }.not_to raise_error
    end
  end

  describe "summoner" do
    it "works by summoners name" do
      name = "foo"
      summoner = client.summoner.find_by_name(name)
      expect(summoner.name).to eq(name)
    end

    let(:summoner) { client.summoner.find_by_name("foo") }

    it "works by summoners id" do
      response = client.summoner.find(summoner.id)
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
