class AgrofundersController < ApplicationController
	before_action :authenticate_user!
	layout 'user_admin'
	def show

	end

	def admin

		@agrofunder = current_user
		@title = "Tus Fundings"
		@buttom = "Añade una Tierra"
		@link = farmlands_map_path
		#binding.pry
		if(@agrofunder.farmlands.size != 0)
			@farmlands = @agrofunder.farmlands
			render 'admin'
		else
			render 'admin_new_user'
		end
	end

	def edit

	end

	def update

	end
end
