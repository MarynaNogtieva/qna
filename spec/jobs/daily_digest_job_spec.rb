require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users){ create_list(:user, 5) }
  let!(:questions){ create_list(:question, 5, user: users.first)}
  it 'sends daily digest' do
    users.each do |recipient|
      expect(DailyMailer).to receive(:digest).with(recipient, questions)
    end
    DailyDigestJob.perform_now
  end
end
