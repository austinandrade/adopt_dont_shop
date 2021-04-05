class CreateApplicants < ActiveRecord::Migration[5.2]
  def change
    create_table :applicants do |t|
      t.string :full_name
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zipcode

      t.timestamps
    end
  end
end
