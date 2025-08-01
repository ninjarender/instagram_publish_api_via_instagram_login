# frozen_string_literal: true

require_relative "api_helper"

module InstagramPublishApiViaInstagramLogin
  # Handles Instagram authentication flow
  class Authenticator
    INSTAGRAM_TOKEN_ENDPOINT = "https://api.instagram.com"

    def initialize(client_id:, client_secret:, redirect_uri:)
      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = redirect_uri
    end

    def exchange_code_for_token(code)
      path = "#{INSTAGRAM_TOKEN_ENDPOINT}/oauth/access_token"

      ApiHelper.post(
        path: path,
        body: {
          client_id: @client_id,
          client_secret: @client_secret,
          grant_type: "authorization_code",
          redirect_uri: @redirect_uri,
          code: code
        },
        headers: { "Content-Type" => "application/x-www-form-urlencoded" }
      )
    end

    private

    attr_reader :client_id, :client_secret, :redirect_uri
  end
end
