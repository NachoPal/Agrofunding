class Farmland < ActiveRecord::Base

	belongs_to :farmer, -> { where type: "Farmer"}, inverse_of: :farmlands, class_name: "Farmer"
end
