class FarmlandsController < ApplicationController

	layout 'farmlands', only: [:index]
	layout 'farmlands_new', only: [:new]

	before_action "save_my_previous_url", only: [:new]

	def new

		@title = "Nueva Tierra"
		@buttom = "Volver"
		#@link = session[:my_previous_url]

		@farmer = Farmer.find params[:id]
		@farmland = @farmer.farmlands.new	
	end

	def create

		@farmer = Farmer.find params[:id]
		
		@farmland = Farmland.find params[:farmland]["id"].to_i

		@farmland.update_attributes entry_params

		@farmland.farmer = @farmer
	
		if(@farmland.save)
			flash[:notice] = "Tierra añadida correctamente"
			redirect_to farmer_admin_path (@farmer)
		else
			flash[:error] = "Error al añadir la tierra"
			render 'new'
		end		
	end

	def show

		@farmland = Farmland.find params[:farm_id]
		@title = @farmland.name
		@buttom = "Volver a Admin"
		@link = farmer_admin_path(params[:id])
	end

	def index

	end

	private

		def entry_params
			params.require(:farmland).permit(:id, :name, :product, :price, :period_start, :period_end)
		end
	
end
