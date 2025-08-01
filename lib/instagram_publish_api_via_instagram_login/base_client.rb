# frozen_string_literal: true

module InstagramPublishApiViaInstagramLogin
  # Base class for Instagram API clients that require access token
  class BaseClient
    INSTAGRAM_GRAPH_API_ENDPOINT = "https://graph.instagram.com"
    GRAPH_API_VERSION = "v23.0"

    def initialize(access_token:)
      @access_token = access_token
    end

    private

    attr_reader :access_token
  end
end
