class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :votes, reject_if: :all_blank, allow_destroy: true

  def vote_for(user)
    votes.create!(user_id: user.id, score: 1)
  end

  def vote_against(user)
    votes.create!(user_id: user.id, score: -1)
  end

  def vote_score
    votes.sum(:score)
  end

  def voted?(user)
    votes.exists?(user_id: user.id)
  end

  def reset_vote(user)
    votes.where(user: user, votable_id: self.id).delete_all
  end
end
