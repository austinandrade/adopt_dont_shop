class AddUserIdToApplications < ActiveRecord::Migration[5.2]
  def change
    add_reference :applications, :user
  end
end
