class ChangeFileColumn < ActiveRecord::Migration[5.1]
  def up
    rename_column :attachments, :file, :files
    change_column :attachments, :files, :json, using: 'files::JSON'
  end

  def down
    change_column :attachments, :files, :string
    rename_column :attachments, :files, :file
  end
end
