require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'ActiveRecord validations' do
    it { should belong_to(:question)}
  end
  
  context 'ActiveModel validations' do
    it { should validate_presence_of(:body) }
  end
end
