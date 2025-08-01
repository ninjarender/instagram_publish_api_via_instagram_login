# frozen_string_literal: true

require_relative "api_helper"
require_relative "base_client"

module InstagramPublishApiViaInstagramLogin
  # Handles Instagram media publishing
  class Publisher < BaseClient
    def publish_media(ig_id:, media_url:, media_type: "IMAGE", caption: nil)
      path = "#{INSTAGRAM_GRAPH_API_ENDPOINT}/#{GRAPH_API_VERSION}/#{ig_id}/media_publish"

      media_container_id = if media_url.is_a?(Array)
                             children_ids = media_url.map do |url|
                               create_media_container(
                                 ig_id: ig_id, media_url: url, is_carousel_item: true, caption: caption
                               )
                             end

                             create_media_container(
                               ig_id: ig_id, media_url: children_ids, media_type: media_type, caption: caption
                             )
                           else
                             create_media_container(
                               ig_id: ig_id, media_url: media_url, media_type: media_type, caption: caption
                             )
                           end

      ApiHelper.post(
        path: path,
        body: { access_token: access_token, creation_id: media_container_id }
      )
    end

    private

    def create_media_container(ig_id:, media_url:, media_type: "IMAGE", is_carousel_item: false, upload_type: nil, caption: nil)
      path = "#{INSTAGRAM_GRAPH_API_ENDPOINT}/#{GRAPH_API_VERSION}/#{ig_id}/media"

      body = { access_token: access_token, media_type: media_type, caption: caption }

      case media_type
      when "IMAGE"
        body[:image_url] = media_url
      when "VIDEO", "REELS", "STORIES"
        body[:video_url] = media_url
      when "CAROUSEL"
        body[:children] = media_url
      end

      body[:is_carousel_item] = is_carousel_item if is_carousel_item
      body[:upload_type] = upload_type if upload_type

      response = ApiHelper.post(path: path, body: body)
      media_container_id = response["id"]

      wait_for_media_container_status(media_container_id: media_container_id)

      media_container_id
    end

    def wait_for_media_container_status(media_container_id:)
      loop do
        status = check_media_container_status(media_container_id: media_container_id)
        break if status["status"] == "FINISHED"

        sleep 30
      end
    end

    def check_media_container_status(media_container_id:)
      path = "#{INSTAGRAM_GRAPH_API_ENDPOINT}/#{GRAPH_API_VERSION}/#{media_container_id}?fields=status_code"

      ApiHelper.get(
        path: path,
        params: { access_token: access_token }
      )
    end
  end
end
