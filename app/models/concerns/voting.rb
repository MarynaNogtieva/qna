module Voting
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
    accepts_nested_attributes_for :votes, reject_if: :all_blank, allow_destroy: true
  end

  def vote_for(user)
    self.votes.create!(user_id: user.id, score: 1)
  end

  def vote_against(user)
    self.votes.create!(user_id: user.id, score: -1)
  end

  def vote_score
    self.votes.sum(:score)
  end

  def voted?(user)
    self.votes.exists?(user_id: user.id)
  end

  def reset_vote(user)
    self.votes.where(user: user, votable_id: self.id).delete_all
  end
end

