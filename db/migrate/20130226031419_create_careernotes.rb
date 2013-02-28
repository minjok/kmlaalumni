class CreateCareernotes < ActiveRecord::Migration
  def change
    create_table :careernotes do |t|
      
      t.text :content, null: false
      t.references :employment
      t.timestamps
      
    end
  end
end
