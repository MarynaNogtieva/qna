class NewAnswerNotificationJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    subscribtions = answer.question.subscriptions
    subscribtions.each do |subscription|
      next if answer.user == subscription.user
      AnswerMailer.notifier(answer, subscription.user).deliver_later
    end
  end
end
