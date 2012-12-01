class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|

      t.timestamps
    end
  end
end
