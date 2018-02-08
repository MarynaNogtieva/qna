class ConvertAttachmentsToPolymorphic < ActiveRecord::Migration[5.1]
  def change
    remove_reference :attachments, :question, index: true, foreign_key: true
    add_column :attachments, :attachable_type, :string #do we need to add FK here?
    add_column :attachments, :attachable_id, :bigint

    add_index :attachments, %i[attachable_id attachable_type]
  end
end
