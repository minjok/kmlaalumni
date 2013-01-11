class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
		
		t.text			:content,		null: false
        t.integer       :platform,      null: false
        t.integer       :viewability,   null: false, default: Posting::VIEWABILITY['ASSOCIATION']
		t.references    :user
        t.references    :group
        t.timestamps
		
    end
  end
end
