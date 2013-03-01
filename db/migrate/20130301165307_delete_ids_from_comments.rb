class DeleteIdsFromComments < ActiveRecord::Migration
  def up
    remove_column :comments, :posting_id
  end

  def down
    add_column :comments, :posting_id
  end
end
