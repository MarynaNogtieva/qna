require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'ActiveRecord validations' do
    it { should have_many(:answers)}
    it { should have_many(:answers).dependent(:destroy)}
  end
  
  context 'ActiveModel validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end
end
