class RemoveIndexFromAttachments < ActiveRecord::Migration
  def change
    remove_index :attachments, :attachable_type
    remove_index :attachments, :attachable_id
  end
end
