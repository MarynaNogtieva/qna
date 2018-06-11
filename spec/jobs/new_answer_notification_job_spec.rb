require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:user){ create(:user) }
  let(:subscribed_user){ create(:user) }
  let(:not_subscribed_users) { create_list(:user, 5) }
  let(:question) { create(:question, user: subscribed_user)}
  let(:answer){ create(:answer,question: question, user: user) }
  it 'sends new answer' do
    expect(AnswerMailer).to receive(:notifier).with(answer, subscribed_user).and_call_original
    NewAnswerNotificationJob.perform_now(answer)
  end
end
