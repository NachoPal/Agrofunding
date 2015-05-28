class Subscription < ActiveRecord::Base

	belongs_to :agrofunder
	belongs_to :farmland
end
