class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    Rails.logger.info "follow method was called for comments recource #{data['id']}"
    stream_from "comments_for_#{data['id']}"
  end
end