class Farmland < ActiveRecord::Base

	belongs_to :farmer, -> { where type: "Farmer"}, inverse_of: :farmlands, class_name: "Farmer"

	
	has_many :fundings
	has_many :agrofunders, -> { where type: "Agrofunder"}, class_name: "Agrofunder", through: :fundings
	#has_many :agrofunders, -> { where type: "Agrofunder"}, class_name: "User", through: :fundings

end
