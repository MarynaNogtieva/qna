class AddIndexesAndUserToVotes < ActiveRecord::Migration[5.1]
  def change
    add_index :votes, %i[votable_type votable_id]
    add_reference :votes, :user, foreign_key: { on_delete: :cascade }
  end
end
