class AddReferencesForCareernote < ActiveRecord::Migration
  def change
    add_column :comments, :careernote_id, :integer
    add_column :likes, :careernote_id, :integer
  end
end
