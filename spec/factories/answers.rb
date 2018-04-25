FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "MyAnswer #{n}" }
    question
    factory :invalid_answer, class: "Answer" do
      body nil
      question nil
    end
  end
end
