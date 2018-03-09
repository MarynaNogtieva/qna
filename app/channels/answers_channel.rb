class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    Rails.logger.info "follow method was called for answers #{data['id']}"
    stream_from "questions_#{data['id']}"
  end
end