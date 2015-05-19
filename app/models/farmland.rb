class Farmland < ActiveRecord::Base

	has_many :fundings
	has_many :users, through: :fundings

	has_many :subscriptions
end
