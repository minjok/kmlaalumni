class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
        t.references	:user
		t.references	:organization
        t.string        :position
        t.date          :start_year
        t.date          :end_year
		t.timestamps
    end
  end
end
