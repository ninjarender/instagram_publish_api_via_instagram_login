# frozen_string_literal: true

require "faraday"
require "json"

module InstagramPublishApiViaInstagramLogin
  # Client for Instagram Publish API via Instagram Login
  class Client
    INSTAGRAM_TOKEN_ENDPOINT = "https://api.instagram.com"
    INSTAGRAM_GRAPH_API_ENDPOINT = "https://graph.instagram.com"
    GRAPH_API_VERSION = "v23.0"

    def initialize(client_id:, client_secret:, redirect_uri:)
      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = redirect_uri
    end

    def exchange_code_for_token(code)
      path = "#{INSTAGRAM_TOKEN_ENDPOINT}/oauth/access_token"
      response = Faraday.post(path) do |req|
        req.headers["Content-Type"] = "application/x-www-form-urlencoded"
        req.body = URI.encode_www_form(client_id: client_id, client_secret: client_secret,
                                       grant_type: "authorization_code",
                                       redirect_uri: redirect_uri, code: code)
      end

      handle_api_response(response)
    end

    def get_user_info(access_token:, fields:)
      path = "#{INSTAGRAM_GRAPH_API_ENDPOINT}/#{GRAPH_API_VERSION}/me"
      response = Faraday.get(path) do |req|
        req.headers["Content-Type"] = "application/json"
        req.params = { access_token: access_token, fields: fields }
      end

      handle_api_response(response)
    end

    def publish_media(ig_id:, access_token:, media_url:, media_type: "IMAGE")
      path = "#{INSTAGRAM_GRAPH_API_ENDPOINT}/#{GRAPH_API_VERSION}/#{ig_id}/media_publish"

      media_container_id = if media_url.is_a?(Array)
                             children_ids = media_url.map do |url|
                               create_media_container(
                                 ig_id: ig_id, access_token: access_token, media_url: url, is_carousel_item: true
                               )
                             end

                             create_media_container(
                               ig_id: ig_id, access_token: access_token, media_url: children_ids, media_type: media_type
                             )
                           else
                             create_media_container(
                               ig_id: ig_id, access_token: access_token, media_url: media_url, media_type: media_type
                             )
                           end

      response = Faraday.post(path) do |req|
        req.headers["Content-Type"] = "application/json"
        req.body = { access_token: access_token, creation_id: media_container_id }.to_json
      end

      handle_api_response(response)
    end

    private

    attr_reader :client_id, :client_secret, :redirect_uri

    def handle_api_response(response)
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

    def create_media_container(ig_id:, access_token:, media_url:, media_type: "IMAGE",
                               is_carousel_item: false, upload_type: nil)
      path = "#{INSTAGRAM_GRAPH_API_ENDPOINT}/#{GRAPH_API_VERSION}/#{ig_id}/media"

      body = { access_token: access_token, media_type: media_type }

      case media_type
      when "IMAGE"
        body[:image_url] = media_url
      when "VIDEO", "REELS", "STORIES"
        body[:video_url] = media_url
      when "CAROUSEL"
        body[:caption] = "Instagram Carousel"
        body[:children] = media_url
      end

      body[:is_carousel_item] = is_carousel_item if is_carousel_item
      body[:upload_type] = upload_type if upload_type

      response = Faraday.post(path) do |req|
        req.headers["Content-Type"] = "application/json"
        req.body = body.to_json
      end

      media_container_id = handle_api_response(response)["id"]

      wait_for_media_container_status(ig_id: ig_id, access_token: access_token,
                                      media_container_id: media_container_id)

      media_container_id
    end

    def wait_for_media_container_status(ig_id:, access_token:, media_container_id:)
      loop do
        status = check_media_container_status(ig_id: ig_id, access_token: access_token,
                                              media_container_id: media_container_id)
        break if status["status"] == "FINISHED"

        sleep 30
      end
    end

    def check_media_container_status(ig_id:, access_token:, media_container_id:)
      path = "#{INSTAGRAM_GRAPH_API_ENDPOINT}/#{GRAPH_API_VERSION}/#{media_container_id}?fields=status_code"
      response = Faraday.get(path) do |req|
        req.headers["Content-Type"] = "application/json"
        req.params = { access_token: access_token }
      end

      handle_api_response(response)
    end
  end
end
