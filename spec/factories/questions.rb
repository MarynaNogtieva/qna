FactoryBot.define do
  factory :question_same do
    title "MyString"
    body "MyText"
  end

  factory :question do
    sequence(:title) { |n| "Title #{n}" }
    body "MyText"
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
