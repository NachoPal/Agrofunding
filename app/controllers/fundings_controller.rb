class FundingsController < ApplicationController

  layout 'landing'

  def new
    @funding = Funding.new

  end

  def create

    @funding = Funding.new funding_params
    @funding.agrofunder = current_user
    
    if(@funding.save)
      redirect_to agrofunder_admin_path(current_user)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def show
  end

  private

  def funding_params
    params.require(:funding).permit(:frecuency, :amount, :farmland_id)
  end
end
