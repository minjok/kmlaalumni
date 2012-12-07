class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
		
		t.text			:content,		null: false
		t.references    :user
        t.references    :group
        t.timestamps
		
    end
  end
end
