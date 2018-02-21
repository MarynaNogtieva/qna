class AddDefaultValuesToScore < ActiveRecord::Migration[5.1]
  def up
    change_column :votes, :score, :integer, default: 0
    change_column_null :votes, :score, false
  end
end
