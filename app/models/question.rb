class Question < ApplicationRecord
  include Voting
  include Commenting

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true


  def add_subscription(user)
    subscriptions.create!(user: user, question: self)
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end
end
