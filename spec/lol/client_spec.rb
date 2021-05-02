require "spec_helper"
require "lol"

include Lol

describe Client do
  subject { Client.new "foo" }
  let(:new_instance_args) do
    [subject.api_key, subject.region, { cached: false, redis: nil, ttl: nil}, nil]
  end

  describe "#new" do
    it "requires an API key argument" do
      expect { Client.new }.to raise_error(ArgumentError)
    end

    it "accepts a region argument" do
      expect { Client.new("foo", :region => "na") }.not_to raise_error
    end

    it "defaults on BR as a region" do
      expect(subject.region).to eq("br")
    end

    context "caching" do
      let(:client) { Client.new "foo", redis: "redis://dummy-url" }
      let(:real_redis) { Client.new "foo", redis: "redis://localhost:6379" }

      xit "sets caching if redis is specified in the options" do
        # ToDo: analyse this private method
        expect(client.cached?).to be_truthy
      end

      it "sets a default ttl of 15 * 60s" do
        expect(client.ttl).to eq(15*60)
      end

      it "accepts a custom ttl" do
        client = Client.new "foo", redis: "redis://dummy-url", ttl: 10
        expect(client.ttl).to eq(10)
      end

      it "instantiates a redis client if redis is in the options" do
        expect(real_redis.instance_variable_get(:@redis)).to be_a(Redis)
      end

      xit "passes the redis_store to the request" do
        # ToDo: analyse this private method
        champion_request = real_redis.champion
        expect(champion_request.cache_store).to eq(real_redis.cache_store)
      end
    end

    context "rate_limiting" do
      let(:client) { Client.new "foo", rate_limit_requests: 10 }

      # ToDo: analyse this private method
      xit "sets rate limiting if specified in the options" do
        expect(client.rate_limited?).to be_truthy
      end

      it "instantiates a rate limiter if it is in the options" do
        expect(client.rate_limiter).not_to be_nil
      end

      it "passes the rate limiter to the request" do
        champion_request = client.champion
        expect(champion_request.rate_limiter).to eq(client.rate_limiter)
      end
    end
  end

  xdescribe "#cached?" do
    # ToDo: analyse this private method
    it "is true if @cached is true" do
      subject.instance_variable_set(:@cached, true)
      expect(subject.cached?).to be_truthy
    end

    it "is false if @cached is false" do
      subject.instance_variable_set(:@cached, false)
      expect(subject.cached?).to be_falsy
    end
  end

  describe "#champion" do
    it "returns an instance of ChampionRequest" do
      expect(subject.champion).to be_a(ChampionRequest)
    end

    it "initializes the ChampionRequest with the current API key and region" do
      expect(ChampionRequest).to receive(:new).with(*new_instance_args)

      subject.champion
    end
  end

  describe '#match' do
    it "returns an instance of MatchRequest" do
      expect(subject.match).to be_a(MatchRequest)
    end

    it "initializes the MatchRequest with the current API key and region" do
      expect(MatchRequest).to receive(:new).with(*new_instance_args)

      subject.match
    end
  end

  describe '#runes' do
    it "returns an instance of RunesRequest" do
      expect(subject.runes).to be_a(RunesRequest)
    end

    it "initializes the RunesRequest with the current API key and region" do
      expect(RunesRequest).to receive(:new).with(*new_instance_args)

      subject.runes
    end
  end

  describe "#league" do
    it "returns an instance of LeagueRequest" do
      expect(subject.league).to be_a(LeagueRequest)
    end

    it "initializes the LeagueRequest with the current API key and region" do
      expect(LeagueRequest).to receive(:new).with(*new_instance_args)

      subject.league
    end
  end

  describe "#summoner" do
    it "returns an instance of SummonerRequest" do
      expect(subject.summoner).to be_a(SummonerRequest)
    end

    it "initializes the SummonerRequest with the current API key and region" do
      expect(SummonerRequest).to receive(:new).with(*new_instance_args)

      subject.summoner
    end
  end

  describe "#static" do
    it "returns an instance of StaticRequest" do
      expect(subject.static).to be_a(StaticRequest)
    end

    it "initializes the StaticRequest with the current API key and region" do
      expect(StaticRequest).to receive(:new).with(*new_instance_args)

      subject.static
    end
  end

  describe '#lol_status' do
    it 'return an instance of LolStatusRequest' do
      expect(subject.lol_status).to be_a(LolStatusRequest)
    end
  end

  describe "#api_key" do
    it "returns an api key" do
      expect(subject.api_key).to eq("foo")
    end

    it "is read_only" do
      expect { subject.api_key = "bar" }.to raise_error(NoMethodError)
    end
  end

  describe "#region" do
    it "returns current region" do
      expect(subject.region).to eq("br")
    end

    it "can be set to a new region" do
      subject.region = "NA"
      expect(subject.region).to eq("NA")
    end
  end

end
