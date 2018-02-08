class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.string :file
      t.belongs_to :question,  null: false, foreign_key: { on_delete: :cascade }
      t.timestamps
    end
  end
end
