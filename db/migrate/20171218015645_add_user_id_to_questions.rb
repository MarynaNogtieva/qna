class AddUserIdToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :questions, :user, null: false, foreign_key: { on_delete: :cascade }
  end
end
