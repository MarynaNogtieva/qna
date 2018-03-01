require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy)}
    it { should belong_to(:user) }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  it { should accept_nested_attributes_for :attachments }
  it { should accept_nested_attributes_for :votes }
  it { should accept_nested_attributes_for :comments }


  describe 'vote_score' do
    let(:user) { @user || create(:user) }
    let(:question) { create(:question, user: user) }

    it 'should create vote for' do
      expect { question.vote_for(user) }.to change(Vote, :count).by(1)
    end

    it 'should create vote against' do
      expect { question.vote_against(user) }.to change(Vote, :count).by(1)
    end

    it 'should set vote for to 1' do
      question.vote_for(user)
      expect(question.vote_score).to eq 1
    end

    it 'should set vote against to -1' do
      question.vote_against(user)
      expect(question.vote_score).to eq -1
    end

    it 'should check if the question was voted for' do
      question.vote_for(user)
      expect(question).to be_voted(user)
    end

    it 'should get a question sum' do
      question.vote_for(user)
      expect(question.vote_score).to eq 1
    end

    it 'should reset score by removing record for this vote' do
      question.vote_for(user)
      expect { question.reset_vote(user) }.to change(Vote, :count).by(-1)
    end
  end
end

