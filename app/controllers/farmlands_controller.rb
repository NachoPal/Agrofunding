class FarmlandsController < ApplicationController
	layout 'application'
	before_action "save_my_previous_url", only: [:new]
	def new

		@title = "Nueva Tierra"
		@buttom = "Volver"
		@link = session[:my_previous_url]

		@farmer = Farmer.find params[:id]
		@farmland = @farmer.farmlands.new

		
	end

	def create

		@farmer = Farmer.find params[:id]
		@farmland = @farmer.farmlands.new entry_params

		if(@farmland.save)
			flash[:notice] = "Tierra añadida correctamente"
			redirect_to farmer_farmland_path(@farmer, @farmland)
		else
			flash[:error] = "Error al añadir la tierra"
		end
	end

	def show

		@farmland = Farmland.find params[:farm_id]
		@title = @farmland.name
		@buttom = "Volver a Admin"
		@link = farmer_admin_path(params[:id])
	end

	def index
		render 'index', layout: 'application'
	end

	private

		def entry_params

			params.require(:farmland).permit(:name, :product, :price, :period_start, :period_end)
		end
	
end
