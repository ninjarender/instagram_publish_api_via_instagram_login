# frozen_string_literal: true

require "faraday"
require "json"

module InstagramPublishApiViaInstagramLogin
  # Helper for handling API requests and responses
  class ApiHelper
    def self.get(path:, params: {}, headers: {})
      response = Faraday.get(path) do |req|
        req.headers.merge!(default_headers.merge(headers))
        req.params = params
      end

      handle_response(response)
    end

    def self.post(path:, body: {}, headers: {})
      response = Faraday.post(path) do |req|
        req.headers.merge!(default_headers.merge(headers))
        req.body = if headers["Content-Type"] == "application/x-www-form-urlencoded"
                     URI.encode_www_form(body)
                   else
                     body.to_json
                   end
      end

      handle_response(response)
    end

    class << self
      private

      def default_headers
        { "Content-Type" => "application/json" }
      end

      def handle_response(response)
        # Check for HTTP error status codes
        unless response.success?
          raise InstagramPublishApiViaInstagramLogin::Error, "HTTP #{response.status}: #{response.body}"
        end

        parsed_response = JSON.parse(response.body)

        # Check for Instagram API errors in response
        if parsed_response["error"]
          error_message = "Instagram API Error: #{parsed_response["error"]}"
          error_message += " - #{parsed_response["error_description"]}" if parsed_response["error_description"]
          raise InstagramPublishApiViaInstagramLogin::Error, error_message
        end

        parsed_response
      rescue Faraday::Error => e
        raise InstagramPublishApiViaInstagramLogin::Error, "HTTP Error: #{e.message}"
      rescue JSON::ParserError => e
        raise InstagramPublishApiViaInstagramLogin::Error, "JSON Parse Error: #{e.message}"
      end
    end
  end
end
