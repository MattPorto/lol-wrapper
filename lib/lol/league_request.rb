module Lol
  # Bindings for the League API.
  #
  # See: https://developer.riotgames.com/api-methods/#league-v4
  class LeagueRequest < Request

    # Get all league entries
    # @param options [Hash]
    # @option options [String] :queue Queue identifier. See (developer.riotgames.com/game-constants.html)
    # @option options [String] :tier League Tier
    # @option options [String] :division League Division
    # @return [Array<DynamicModel>] List of League Summoners
    def entries(options = { queue: default_queue })
      division = parsed_division options[:division]
      tier = parsed_tier options[:tier]
      url = api_url "entries/#{options[:queue]}/#{tier}/#{division}"
      request_handler_for_collection url
    end

    # Get leagues in all queues for a given summoner ID
    # @param [Integer] summoner_id Encrypted summoner ID associated with the player
    # @return [Array<DynamicModel>] List of leagues summoner is participating in
    def summoner_leagues(summoner_id)
      url = api_url "entries/by-summoner/#{summoner_id}"
      request_handler_for_collection url
    end

    # Get the master league for a given queue
    # @param [String] queue Queue identifier. See the list of game constants (developer.riotgames.com/game-constants.html) for the available queue identifiers
    # @return [DynamicModel] Master league
    def masters(queue = default_queue)
      queue_league 'master', queue
    end

    # Get the grandmaster league for a given queue
    # @param [String] queue Queue identifier. See the list of game constants (developer.riotgames.com/game-constants.html) for the available queue identifiers
    # @return [DynamicModel] GrandMaster league
    def grandmasters(queue = default_queue)
      queue_league 'grandmaster', queue
    end

    # Get the challenger league for a given queue
    # @param [String] queue Queue identifier. See (developer.riotgames.com/game-constants.html)
    # @return [DynamicModel] Challenger league
    def challengers(queue = default_queue)
      queue_league 'challenger', queue
    end

    # Get league with given ID, including inactive entries
    # @param [Integer] league_id The UUID of the league
    # @return [DynamicModel] League Representation
    def by_id(league_id)
      url = api_url "leagues/#{league_id}"
      request_handler_for_object url
    end

    private

    def request_handler_for_collection(url)
      result = perform_request url
      result.map { |c| DynamicModel.new c }
    end

    def request_handler_for_object(url)
      result = perform_request url
      DynamicModel.new result
    end

    def queue_league(slug, queue)
      url = api_url "#{slug}leagues/by-queue/#{queue}"
      request_handler_for_object url
    end

    def api_base_path
      "/lol/league/#{api_version}"
    end

    def default_queue
      'RANKED_SOLO_5x5'
    end

    def parsed_division(division)
      case division.to_s
      when '1' then 'I'
      when '2' then 'II'
      when '3' then 'III'
      when '4' then 'IV'
      else division.to_s
      end
    end

    def parsed_tier(tier)
      tier.to_s.upcase
    end
  end
end
