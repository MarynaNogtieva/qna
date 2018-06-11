require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 5, user: user) }
    let(:mail) { DailyMailer.digest(user, questions) }

    it "renders headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders body" do
      expect(mail.body.encoded).to match("Here are questions for the last 24 hours")
    end
  end
end
