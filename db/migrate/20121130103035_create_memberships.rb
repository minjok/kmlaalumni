class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
		
		t.integer	:user_id, 	null: false
		t.integer	:group_id,	null: false
		t.boolean	:admin, 	null: false, default: false
		
    end
  end
end
