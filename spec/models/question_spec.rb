require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy)}
    it { should belong_to(:user) }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  it { should accept_nested_attributes_for :attachments }
  it { should accept_nested_attributes_for :votes }
  it { should accept_nested_attributes_for :comments }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create :question, user: user }

  describe '#add_subscription' do
    it 'subscribes a user to a certain question' do
      expect(question.subscriptions).to include(question.add_subscription(other_user))
    end
  end

  describe '#subscribed?' do
    it 'returns true once subscription for certain user was created' do
      question.add_subscription(other_user)
      expect(question.subscriptions.where(user_id: other_user.id)).to be_present
    end
  end

  describe '#remove_subscriptions' do
    it 'unsubscribes user from a question' do
      expect(question.subscriptions).to_not include(question.remove_subscription(other_user))
    end
  end

  let!(:object_name) { :question }
  it_behaves_like 'Votable Model'
end

