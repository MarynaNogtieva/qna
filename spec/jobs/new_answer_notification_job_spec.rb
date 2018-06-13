require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:user){ create(:user) }
  let(:not_subscribed_users) { create_list(:user, 5) }
  let(:question) { create(:question, user: user)}
  let!(:users) { create_list(:user, 10) }

  let!(:answer){ create(:answer,question: question, user: user) }
  it 'sends new answer' do
    users.each do |subscribed_user|
      subscribed_user.add_subscription(question)
      expect(AnswerMailer).to receive(:notifier).with(answer, subscribed_user)
    end
    NewAnswerNotificationJob.perform_now(answer)
  end


  it 'sends notification to existing subscribers only' do
    not_subscribed_users.each do |not_subscribed_user|
      expect(AnswerMailer).to_not receive(:notifier).with(answer, not_subscribed_user)
    end

    NewAnswerNotificationJob.perform_now(answer)
  end
end
