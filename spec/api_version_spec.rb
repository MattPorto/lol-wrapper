require "spec_helper"
require "lol"
include Lol

def check_api_version(klass, version)
  describe klass do
    it "should use API version #{version}" do
      expect(klass.api_version).to eq(version)
    end
  end
end

describe "API Versions" do
  modules = [ChampionRequest, ChampionMasteryRequest,  LeagueRequest,
             StaticRequest, LolStatusRequest, MatchRequest, SummonerRequest,
             RunesRequest, SpectatorRequest]

  modules.each {|m| check_api_version(m, "v4")}
end
