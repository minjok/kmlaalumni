class CreateAlumniVerifications < ActiveRecord::Migration
  
  def change
    create_table :alumni_verifications do |t|
      t.string  :name,  null:false
      t.string  :student_number,  null:false
    end
  end
  
end
