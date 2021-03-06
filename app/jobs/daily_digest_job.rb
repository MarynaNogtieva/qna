class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    questions = Question.last_day
    User.find_each.each do |user|
      DailyMailer.digest(user, questions).try(:deliver_later)
    end
  end
end
