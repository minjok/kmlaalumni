class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
     
      t.text      :content,      null: false
      t.references :user
      t.references :posting
      t.timestamps
    
    end
  end
end
