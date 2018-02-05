FactoryBot.define do
  factory :attachment do
    # association :attachable, factory: :question_with_attachments
    # attaches file lazily to the factory when we build a new one
    # files Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/support/acceptance_helpers.rb')))

    # if we use method create to create records that are persisted in DB
    after :create do |b|
      b.update_column(:files, "[baz.rb]")
    end
  end
end
