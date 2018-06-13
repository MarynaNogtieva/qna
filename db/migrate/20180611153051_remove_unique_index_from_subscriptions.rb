class RemoveUniqueIndexFromSubscriptions < ActiveRecord::Migration[5.1]
  def change
    remove_index :subscriptions, column: [:user_id, :question_id], unique: true
    add_index :subscriptions, [:user_id, :question_id]
  end
end
