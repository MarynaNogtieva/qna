class Answer < ApplicationRecord
  include Voting
  include Commenting
  
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :body, presence: true
  
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :votes, reject_if: :all_blank, allow_destroy: true
  
  after_create :notify_about_new_answer, on: :create

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_best
    transaction do
      question.answers.update_all(best: false)
      reload.update!(best: true)
    end
  end

  def notify_about_new_answer
    NewAnswerNotificationJob.perform_later(self)
  end
end
