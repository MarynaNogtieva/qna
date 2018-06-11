class Question < ApplicationRecord
  include Voting
  include Commenting

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :last_day, -> { where(created_at: 24.hours.ago..Time.now) }

  after_create :subscribe_owner

  def add_subscription(user)
    subscriptions.create!(user: user)
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end

  def remove_subscription(user)
    subscriptions.where(user: user).destroy_all
  end

  private

  def subscribe_owner
    subscriptions.create!(user: user)
  end
end
