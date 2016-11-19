class CreatePersonalDetails < ActiveRecord::Migration[5.0]
  def change
  	create_table :personal_details do |p|

  		p.string :qualification
  		p.string :institution
  		p.string :time_period

  	end
  end
end
