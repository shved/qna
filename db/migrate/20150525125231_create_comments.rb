class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body

      t.timestamps null: false
    end
    add_reference :comments, :user, index: true
  end
end
