class QuestionsChannel < ApplicationCable::Channel
  def follow
    Rails.logger.info "follow method was called"
    stream_from 'questions'
  end
end