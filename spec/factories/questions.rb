FactoryBot.define do
  factory :question_same do
    title "MyString"
    body "MyText"
  end

  factory :question do
    association :user, factory: :user
    sequence(:title) { |n| "Title #{n}" }
    sequence(:body) { |n| "MyText #{n}" }

    factory :invalid_question do
      title nil
      body nil
    end

    factory :question_with_attachments do
      association :user, factory: :user
      sequence(:title) { |n| "Title #{n}" }
      sequence(:body) { |n| "MyText #{n}" }
      after :build do |question, eval|
        question.attachments << create(:attachment)
      end
    end
  end
end
