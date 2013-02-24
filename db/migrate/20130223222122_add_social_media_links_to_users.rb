class AddSocialMediaLinksToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb, :string
    add_column :users, :tw, :string
    add_column :users, :ln, :string
    add_column :users, :blog, :string
  end
end
