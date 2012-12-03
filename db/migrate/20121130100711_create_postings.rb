class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
		
		t.integer		:user_id,		null: false
		t.integer		:group_id,		null: false
		t.text			:content,		null: false
		t.timestamps
		
    end
  end
end
