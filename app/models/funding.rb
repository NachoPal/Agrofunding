class Funding < ActiveRecord::Base

	belongs_to :farmland
	belongs_to :agrofunder, -> { where type: "Agrofunder"}, class_name: "Agrofunder"
end
