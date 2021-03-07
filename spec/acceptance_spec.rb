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
  let!(:client)   { Lol::Client.new api_key }
  let!(:summoner) { client.summoner.find_by_name('foo') }

  context "stats" do
    it "platform data" do
      stats_keys = %w[id name locales maintenances incidents]

      result = client.lol_status.platform_data

      expect(result.raw.keys).to eq(stats_keys)
    end
  end

  context "champion mastery" do
    it 'all' do
      expect { client.champion_mastery.all summoner.id }.not_to raise_error
    end

    it 'find' do
      expect { client.champion_mastery.find(40, summoner.id) }.not_to raise_error
    end

    it 'total score' do
      expect { client.champion_mastery.total_score summoner.id }.not_to raise_error
    end

  end

  context "champion" do
    pending "rotation"
  end

  context "summoner" do
    it "by name" do
      expect { client.summoner.find_by_name(summoner.name) }.not_to raise_error
    end

    it "by id" do
      expect { client.summoner.find(summoner.id) }.not_to raise_error
    end

    it "by account id" do
      expect { client.summoner.find_by_account_id(summoner.account_id) }.not_to raise_error
    end
  end

  context "matches" do
    let(:summoner) { client.summoner.find_by_name('foo') }

    it "recent" do
      expect { client.match.recent(summoner.account_id) }.not_to raise_error
    end

    context 'all' do
      it 'no filters' do
        expect { client.match.all(summoner.account_id) }.not_to raise_error
      end

      it 'with filters' do
        options = { beginTime: (Time.now - 1800).to_i }
        expect { client.match.all(summoner.account_id, options) }.not_to raise_error
      end
    end
  end

  context "league" do
    it 'entries' do
      options = { queue: 'RANKED_SOLO_5x5', tier: 'SILVER', division: 'IV' }
      expect { client.league.entries(options) }.not_to raise_error
    end

    it 'masters' do
      expect { client.league.masters('RANKED_SOLO_5x5') }.not_to raise_error
    end

    it 'grandmasters' do
      expect { client.league.grandmasters('RANKED_SOLO_5x5') }.not_to raise_error
    end

    it 'challengers' do
      expect { client.league.challengers('RANKED_SOLO_5x5') }.not_to raise_error
    end

    it "summoner leagues" do
      summoner = client.summoner.find_by_name('foo')
      expect { client.league.summoner_leagues(summoner.id) }.not_to raise_error
    end

    it 'league by id' do
      master_league = client.league.masters
      expect { client.league.by_id(master_league.league_id) }.not_to raise_error
    end

  end

  # maybe in next release

  context "clash" do
    pending
  end

  context "tournament" do
    pending
  end

  xcontext "lol-static-data" do
    xcontext "champions" do
      # FIXME: 403 with api key
      # riot games does not support a championlist endpoint
      # one solution is integrate with ddragon API (which runs away of the gem's purpose)
      it "works on the collection" do
        expect { client.champion.all }.not_to raise_error
      end

      it "works on the single champion" do
        expect {client.champion.get(:id => champions.first.id)}.not_to raise_error
      end
    end
  end
end
