require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question)}
    it { should belong_to(:user) }
    it { should have_many(:attachments) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  it { should accept_nested_attributes_for :attachments }
  it { should accept_nested_attributes_for :votes }
  it { should accept_nested_attributes_for :comments }

  let!(:object_name) { :answer }
  it_behaves_like 'Votable Model'
end
