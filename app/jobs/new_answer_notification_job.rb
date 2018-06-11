class NewAnswerNotificationJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    subscribtions = answer.question.subscriptions
    subscribtions.each do |subscription|
      next if subscription.user.author_of?(answer)
      AnswerMailer.notifier(answer, subscription.user).deliver_later
    end
  end
end
