class AddForeignKeyToUploads < ActiveRecord::Migration
  def change
    add_reference :uploads, :user, index: true
    add_foreign_key :uploads, :users
  end
end
