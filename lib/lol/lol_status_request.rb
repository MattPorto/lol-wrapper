module Lol
  # Bindings for the Status API.
  #
  # See: https://developer.riotgames.com/api-methods/#lol-status-v3
  class LolStatusRequest < Request
    # @!visibility private
    def api_base_path
      "/lol/status/#{self.class.api_version}"
    end

    # Get League of Legends status for the given platform
    # @return [DynamicModel]
    def platform_data
      DynamicModel.new perform_request api_url "platform-data"
    end
  end
end
