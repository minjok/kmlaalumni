class DeleteIdsFromLikes < ActiveRecord::Migration
  def up
    remove_column :likes, :posting_id
    remove_column :likes, :comment_id
  end

  def down
    add_column :likes, :posting_id, :integer
    add_column :likes, :comment_id, :integer
  end
end
