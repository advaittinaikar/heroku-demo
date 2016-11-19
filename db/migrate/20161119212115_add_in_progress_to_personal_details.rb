class AddInProgressToPersonalDetails < ActiveRecord::Migration[5.0]
  def change

  	add_column :personal_details, :is_in_progress, :boolean, default:false

  end
end
