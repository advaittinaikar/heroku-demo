class PersonalDetail < ActiveRecord::Base

	validates_presence_of :category
	validates_presence_of :qualification
	validates_presence_of :time_period
	validates_presence_of :institution

end