class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
	
		t.references	:user
		t.references	:school
		
    end
  end
end
