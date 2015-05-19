class Fundings < ActiveRecord::Base

	belongs_to :user 
	belongs_to :farmland
	
end
