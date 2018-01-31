require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question)}
    it { should belong_to(:user) }
    it { should have_many(:attachments) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  it { should accept_nested_attributes_for :attachments}
end
