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
  end
end
