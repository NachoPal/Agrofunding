class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

 #  def after_sign_in_path_for(resource)
 #  	current_user_path
	# end

	# def after_sign_out_path_for(resource)
 #  	current_user_path
	# end

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
