class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|

      t.references :user
      t.references :posting
      t.references :comment
      t.timestamps
      
    end
  end
end
