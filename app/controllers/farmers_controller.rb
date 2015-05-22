class FarmersController < ApplicationController

	before_action :authenticate_user!
	def show

	end

	def admin

		@farmer = current_user

		@farms_owned = @farmer.farmlands

		
		
	end

	def edit

	end

	def update

	end
	
end
