class AddUserIdToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :answers, :user, intex: true, foreign_key: true, null: false
  end
end
