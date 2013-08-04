class AddTypeToTag < ActiveRecord::Migration
  def change
    add_column :tags, :type, :string, :default => "HashTag"
  end
end
