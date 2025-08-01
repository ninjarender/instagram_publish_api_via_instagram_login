# frozen_string_literal: true

require_relative "api_helper"
require_relative "base_client"

module InstagramPublishApiViaInstagramLogin
  # Handles Instagram user information retrieval
  class UserDetails < BaseClient
    def get_user_info(fields:)
      path = "#{INSTAGRAM_GRAPH_API_ENDPOINT}/#{GRAPH_API_VERSION}/me"

      ApiHelper.get(
        path: path,
        params: { access_token: access_token, fields: fields }
      )
    end

    def get_long_lived_access_token(client_secret:)
      path = "#{INSTAGRAM_GRAPH_API_ENDPOINT}/access_token"

      ApiHelper.get(
        path: path,
        params: { access_token: access_token, client_secret: client_secret, grant_type: "ig_exchange_token" }
      )
    end

    def refresh_access_token
      path = "#{INSTAGRAM_GRAPH_API_ENDPOINT}/refresh_access_token"

      ApiHelper.get(
        path: path,
        params: { access_token: access_token, grant_type: "ig_refresh_token" }
      )
    end
  end
end
