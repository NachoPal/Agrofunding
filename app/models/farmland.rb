class Farmland < ActiveRecord::Base

	belongs_to :farmer, -> { where type: "Farmer"}, inverse_of: :farmlands, class_name: "Farmer"

	has_many :fundings
	has_many :agrofunders, -> { where type: "Agrofunder"}, class_name: "Agrofunder", through: :fundings
	#has_many :agrofunders, -> { where type: "Agrofunder"}, class_name: "User", through: :fundings

	def frecuency_for(id)
		self.fundings.where(agrofunder_id: id).first.frecuency
	end

	# def price_for(id)
	# 	self.fundings.where(agrofunder_id: id).first.price
	# end

	def amount_for(id)
		self.fundings.where(agrofunder_id: id).first.amount
	end

	def time_to_delivery_for(id)
		funding_init_date = self.fundings.where(agrofunder_id: id).first.created_at 
		period_type = {:Quincenal => 15, :Mensual => 30, :Trimestral => 90, :Semestral => 180, :Anual => 360}
		frecuency = frecuency_for(id)

		remaining_days = period_type[frecuency.to_sym] - (((Time.zone.now - (funding_init_date - 7.day)) / 1.day).to_i % period_type[frecuency.to_sym])
	end
end





