class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
	
		t.references	:user
		t.references	:school
        t.string        :major
        t.string        :degree
        t.date          :entrance_year
        t.date          :graduation_year
		t.timestamps
        
    end
  end
end
