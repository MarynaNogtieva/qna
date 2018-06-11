require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }
  
  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }
    it { should be_able_to :manage, :all }
  end
  
  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question, user: user }
    let(:non_author_question) { create :question, user: other }
    let(:answer) { create :answer, user: user, question: question }
    let(:non_author_answer) { create :answer, user: other, question: question }
    let(:user_subscription) { create :subscription, user: user, question: question}

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    context 'Question' do
      it { should be_able_to :update, question, user: user }
      it { should_not be_able_to :update, non_author_question, user: user }
      it { should be_able_to :destroy, question, user: user }
      it { should_not be_able_to :destroy, non_author_question, user: user }
      it { should be_able_to :comment, Question }
      it { should be_able_to :vote_for, non_author_question, user: user }
      it { should be_able_to :vote_against, non_author_question, user: user }
      it { should be_able_to :reset_vote, non_author_question, user: user }
      it { should_not be_able_to :vote_for, question, user: user }
      it { should_not be_able_to :vote_against, question,  user: user }
      it { should_not be_able_to :reset_vote, question, user: user }
      it { should be_able_to :create, Subscription }
      it { should be_able_to :destroy, user_subscription, user: other }
     end

    context 'Answer' do
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, non_author_answer }
      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, non_author_answer }
      it { should be_able_to :best_answer, non_author_answer }
      it { should_not be_able_to :best_answer, create(:answer, user: other, question:  non_author_question) }
      it { should be_able_to :comment, Answer }
      it { should be_able_to :vote_for, non_author_answer }
      it { should be_able_to :vote_against, non_author_answer}
      it { should be_able_to :reset_vote, non_author_answer }
      it { should_not be_able_to :vote_for, answer }
      it { should_not be_able_to :vote_against, answer }
      it { should_not be_able_to :reset_vote, answer }
    end
  end 
end