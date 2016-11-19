class Schedule < ActiveRecord::Base

	validates_presence_of	:week
	validates_presence_of	:number_of_classes
	validates_presence_of	:number_of_assignments
	validates_presence_of	:lectures
	validates_presence_of	:assignments

end