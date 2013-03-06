class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :feedable_id
      t.string :feedable_type
      t.integer :venue_id
      t.string :venue_type
      t.boolean :is_public, null: false, default: true
      t.timestamps
      t.references :user
    end
    add_index :activities, :feedable_id
    add_index :activities, :feedable_type
    add_index :activities, :venue_id
    add_index :activities, :venue_type
    Posting.all.each do |posting|
      a = Activity.new
      a.feedable = posting
      a.created_at = posting.created_at
      a.updated_at = posting.updated_at
      a.user = posting.user
      if posting.viewability == Posting::VIEWABILITY['GROUP']
        a.is_public = false
        a.venue = posting.group
      else
        a.is_public =true
      end
      a.save!
    end
    Careernote.all.each do |careernote|
      a = Activity.new
      a.feedable = careernote
      a.created_at = careernote.created_at
      a.updated_at = careernote.updated_at
      a.user = careernote.user
      a.save!
    end
  end
end
