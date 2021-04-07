class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :status
      t.string :description

      t.timestamps
    end
  end
end
