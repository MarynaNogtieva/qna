class AddQuestionIdToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :answers, :question
    add_foreign_key :answers, :questions, on_delete: :cascade
  end
end
