class RemoveInProgressFromPersonalDetails < ActiveRecord::Migration[5.0]
  def change

  	remove_column :personal_details, :is_in_progress

  end
end
