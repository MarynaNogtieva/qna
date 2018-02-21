class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :votes, reject_if: :all_blank, allow_destroy: true
end
