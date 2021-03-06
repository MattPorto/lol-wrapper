module Lol
  # Bindings for the League API.
  #
  # See: https://developer.riotgames.com/api-methods/#league-v3
  class LeagueRequest < Request
    # Get all the league entries
    # @param options [Hash]
    # @option options [String] :queue Queue identifier. See the list of game constants (developer.riotgames.com/game-constants.html) for the available queue identifiers
    # @option options [String] :tier League tier
    # @option options [String] :division League division
    def entries(options = {})
      division = parsed_division(options[:division])
      tier = parsed_tier(options[:tier])
      url = api_url("entries/#{options[:queue]}/#{tier}/#{division}")
      request_handler(url)
    end

    # Get the challenger league for a given queue
    # @param [String] queue Queue identifier. See the list of game constants (developer.riotgames.com/game-constants.html) for the available queue identifiers
    # @return [DynamicModel] Challenger league
    def find_challenger queue: 'RANKED_SOLO_5x5'
      DynamicModel.new perform_request api_url "challengerleagues/by-queue/#{queue}"
    end

    # Get the master league for a given queue
    # @param [String] queue Queue identifier. See the list of game constants (developer.riotgames.com/game-constants.html) for the available queue identifiers
    # @return [DynamicModel] lMaster league
    def find_master queue: 'RANKED_SOLO_5x5'
      DynamicModel.new perform_request api_url "masterleagues/by-queue/#{queue}"
    end

    # Get leagues in all queues for a given summoner ID
    # @param [Integer] summoner_id Encrypted summoner ID associated with the player
    # @return [Array<DynamicModel>] List of leagues summoner is participating in
    def summoner_leagues(summoner_id)
      url = api_url("entries/by-summoner/#{summoner_id}")
      request_handler(url)
    end

    # Get league positions in all queues for a given summoner ID
    # @param [Integer] encrypted_summoner_id Encrypted summoner ID associated with the player
    # @return [Array<DynamicModel>] list of league positions
    def summoner_positions encrypted_summoner_id:
      result = perform_request api_url "positions/by-summoner/#{encrypted_summoner_id}"
      result.map { |c| DynamicModel.new c }
    end

    private

    def request_handler(url)
      result = perform_request(url)
      result.map { |c| DynamicModel.new c }
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
      else ''
      end
    end

    def parsed_tier(tier)
      tier.to_s.upcase
    end
  end
end
