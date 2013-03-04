class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :feedable_id, null: false
      t.string :feedable_type, null: false
      t.boolean :is_public, null: false, default: true
      t.timestamps
      t.references :user
    end
    add_index :activities, :feedable_id
    add_index :activities, :feedable_type
    Posting.all.each do |posting|
      is_public = posting.viewability == 1
      a = Activity.new(is_public: is_public)
      a.feedable = posting
      a.created_at = posting.created_at
      a.updated_at = posting.updated_at
      a.user = posting.user
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
