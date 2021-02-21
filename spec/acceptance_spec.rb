require "spec_helper"
require "lol"
require "awesome_print"

# Requires connection
describe "Live API testing", :remote => true do
  before(:all) do
    VCR.configure do |c|
      c.allow_http_connections_when_no_cassette = true
    end
  end

  let(:api_key)  { ENV['RIOT_GAMES_API_KEY'] } # FIXME: returns nil value
  let(:client)   { Lol::Client.new api_key }
  let(:fallback) { Lol::Client.new ENV['RIOT_GAMES_NEW_KEY'] }

  describe "champion" do
    it "works on the collection" do
      # FIXME: returns 401 without key and 403 with api key
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
      expect {fallback.league.get intinig.id}.not_to raise_error
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

  describe "stats" do
    pending
  end

  describe "summoner" do
    pending
  end

  describe "team" do
    pending
  end
end
