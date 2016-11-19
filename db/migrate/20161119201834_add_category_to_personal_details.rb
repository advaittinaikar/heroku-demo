class AddCategoryToPersonalDetails < ActiveRecord::Migration[5.0]
  def change

  	add_column :personal_details, :category, :string
  	
  end
end
