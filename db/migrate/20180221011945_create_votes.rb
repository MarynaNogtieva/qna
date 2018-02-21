class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :score
      t.string :votable_type
      t.bigint :votable_id

      t.timestamps
    end
  end
end
