class CreateCareernotes < ActiveRecord::Migration
  def change
    create_table :careernotes do |t|

      t.timestamps
    end
  end
end
