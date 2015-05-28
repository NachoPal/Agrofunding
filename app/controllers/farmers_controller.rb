class FarmersController < ApplicationController
	
	before_action :authenticate_user!

	layout 'user_admin'

	def show

	end

	def admin

		@farmer = current_user
		@title = "Tus Tierras"
		@buttom = "Registra una tierra"
		@link = farmer_farmland_new_path

		if(@farmer.farmlands)
			@farms_owned = @farmer.farmlands
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
