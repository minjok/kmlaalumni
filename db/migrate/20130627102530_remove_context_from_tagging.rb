class RemoveContextFromTagging < ActiveRecord::Migration
  def up
    remove_column :taggings, :context
  end

  def down
    add_column :taggings, :context, :string
  end
end
