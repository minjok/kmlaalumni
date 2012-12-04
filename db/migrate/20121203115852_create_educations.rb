class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
	
		t.integer	:user_id,	null: false
		t.integer	:school_id, null: false
		
    end
  end
end
