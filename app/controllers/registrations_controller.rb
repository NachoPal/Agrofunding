class RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]
   def update

    if resource_class == Farmer
      user = :farmer
    elsif resource_class == Agrofunder
      user = :agrofunder
    end

         @user = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
           @user.update_attribute(:name , params[user][:name])
           @user.update_attribute(:surname , params[user][:surname])
           @user.update_attribute(:community, params[user][:community])
           @user.update_attribute(:municipality, params[user][:municipality])
           @user.update_attribute(:city, params[user][:city])
           @user.update_attribute(:address, params[user][:address])
           @user.update_attribute(:postal_code, params[user][:postal_code])
           @user.update_attribute(:telephone, params[user][:telephone])
           @user.update_attribute(:company, params[user][:company])
           @user.update_attribute(:description, params[user][:description])
           @user.update_attribute(:website, params[user][:website])

          
      
            
       #@identification = @user.id
      if user == :farmer
           redirect_to farmer_admin_path(@user)
      elsif user == :agrofunder
          redirect_to farmlands_map_path
      end
          



      def update_resource(resource, params)
        resource.update_without_password(params)
      end
  end
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create

  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.


    def after_sign_up_path_for(resource)
      
      if resource_class == Farmer
        edit_farmer_registration_path
      elsif resource_class == Agrofunder
        edit_agrofunder_registration_path
      else
        "/"
      end
    end

    

end
  

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

