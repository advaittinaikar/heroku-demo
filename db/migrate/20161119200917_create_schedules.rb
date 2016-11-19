class CreateSchedules < ActiveRecord::Migration[5.0]
  def change

  	create_table :schedules do |s|

  		s.datetime 	:week
  		s.integer	:number_of_classes
  		s.string	:lectures
  		s.integer	:number_of_assignments
  		s.string	:assignments

  	end

  end
end
