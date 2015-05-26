class RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]
  layout "landing"
  
   def update

    @user = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource_class == Farmer
      @user.update_attributes(farmer_params)
      redirect_to farmer_admin_path(@user)

    elsif resource_class == Agrofunder
      @user.update_attributes(agrofunder_params)
      redirect_to agrofunder_admin_path(@user)
    end

         
    # def update_resource(resource, params)
    #   resource.update_without_password(params)
    # end
  end


  def after_sign_up_path_for(resource)
    
    if resource_class == Farmer
      edit_farmer_registration_path
    elsif resource_class == Agrofunder
      edit_agrofunder_registration_path
    else
      "/"
    end
  end

  private

  def agrofunder_params
    params.require(:agrofunder).permit(:name, :surname, :community, :municipality, :city, :adress, :postal_code,
                         :telephone, :company, :description)
  end

  def farmer_params
    params.require(:farmer).permit(:name, :surname, :community, :municipality, :city, :adress, :postal_code,
                         :telephone, :company, :description)
  end
end
  


