FactoryBot.define do
  factory :attachment do
    file "MyString"

    factory :attachment_api do
      # file "MyString"
      file { File.new("#{Rails.root}/spec/spec_helper.rb") }
      attachable nil
    end
  end
end
