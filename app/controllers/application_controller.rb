class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  
  def save_my_previous_url
    session[:my_previous_url] = URI(request.referer).path
  end

  def after_sign_in_path_for(resource)

    if(current_user.class == Farmer)
      request.env['omniauth.origin'] || stored_location_for(resource) || farmer_admin_path(current_user.id)
  
    elsif(current_user.class == Agrofunder)
      request.env['omniauth.origin'] || stored_location_for(resource) || agrofunder_admin_path(current_user.id)
    end
  end

  def resource_name
    :agrofunder
  end

  def resource
    @resource ||= User.new(type: "Agrofunder")
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:agrofunder]
  end


  def resource_name2
    :farmer
  end

  def resource2
    @resource2 ||= User.new(type: "Farmer")
  end

  def devise_mapping2
    @devise_mapping2 ||= Devise.mappings[:farmer]
  end

  helper_method :resource2, :resource_name2, :devise_mapping2
  helper_method :resource, :resource_name, :devise_mapping
end
