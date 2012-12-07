class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
		
		t.boolean	:admin, 	null: false, default: false
		t.references :user
        t.references :group
        
    end
  end
end
