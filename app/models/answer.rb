class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  validates  :body, presence: true

  scope :sort_by_best_answer, -> {order(best: :desc)}

  def mark_best_answer
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
