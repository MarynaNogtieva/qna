FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "MyAnswer #{n}" }
    question nil
    factory :invalid_answer, class: "Answer" do
      body nil
      question nil
    end

    factory :answer_with_attachments, class: "Answer"  do
      sequence(:body) { |n| "MyText #{n}" }
      question nil
      after :build do |answer, eval|
        answer.attachments << create(:attachment)
      end
    end
  end
end
