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
    it "by name" do
      name = 'foo'

      result = client.summoner.find_by_name(name)

      expect(result.name).to eq(name)
    end

    it "by id" do
      summoner = client.summoner.find_by_name('foo')

      result = client.summoner.find(summoner.id)

      expect(result.id).to eq(summoner.id)
    end

    it "by account id" do
      summoner = client.summoner.find_by_name('foo')

      result = client.summoner.find_by_account_id(summoner.account_id)

      expect(result.id).to eq(summoner.id)
    end
  end

  describe "matches" do
    let(:summoner) { client.summoner.find_by_name('foo') }

    it "recent" do
      account_id = summoner.account_id

      result = client.match.recent(account_id)

      expect(result['matches'].size).to eq(20)
      expect(result['total_games']).to eq(20)
    end

    context 'all' do
      it 'no filters' do
        account_id = summoner.account_id

        result = client.match.all(account_id)

        # there's a bug on riot macthlist endpoint that returns wrong total games value
        # fo sure I consider a error margin of 10 matches
        expect(result['total_games']).to be_within(10).of(result['matches'].size)
        expect(result['total_games']).not_to be_zero
      end

      it 'with filters' do
        start_time = (Time.now - 1800).to_i
        account_id = summoner.account_id
        options = { beginTime: start_time }

        result = client.match.all(account_id, options)

        expect(result['total_games']).to be_within(10).of(result['matches'].size)
      end
    end
  end

  describe "league" do
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

  end

  describe "match" do
    pending
  end

  describe "match history" do
    pending
  end

  # maybe in next release

  describe "clash" do
    pending
  end

  xdescribe "champion" do
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

  describe "lol-static-data" do
    pending
  end
end
