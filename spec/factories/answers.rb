FactoryBot.define do
  factory :answer do
    body "MyAnswer"
    question nil
    factory :invalid_answer, class: "Answer" do
      body nil
      question nil
    end
  end
end
