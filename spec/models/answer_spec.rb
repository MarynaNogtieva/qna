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


  describe 'vote_score' do
    let(:user) { @user || create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }

    it 'should create vote for' do
      expect { answer.vote_for(user) }.to change(Vote, :count).by(1)
    end

    it 'should create vote against' do
      expect { answer.vote_against(user) }.to change(Vote, :count).by(1)
    end

    it 'should set vote for to 1' do
      answer.vote_for(user)
      expect(answer.vote_score).to eq 1
    end

    it 'should set vote against to -1' do
      answer.vote_against(user)
      expect(answer.vote_score).to eq -1
    end

    it 'should check if the answer was voted for' do
      answer.vote_for(user)
      expect(answer).to be_voted(user)
    end

    it 'should get a answer sum' do
      answer.vote_for(user)
      expect(answer.vote_score).to eq 1
    end

    it 'should reset score by removing record for this vote' do
      answer.vote_for(user)
      expect { answer.reset_vote(user) }.to change(Vote, :count).by(-1)
    end
  end
end
