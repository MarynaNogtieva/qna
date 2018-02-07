class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true
  
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_best
    transaction do
      question.answers.update_all(best: false)
      reload.update!(best: true)
    end
  end
end
