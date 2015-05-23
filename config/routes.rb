Rails.application.routes.draw do
  
  get "/" => "sites#home", as: :root

  devise_for :users, skip: [:registration, :password],
              :controllers => {:sessions =>"sessions"}

  devise_for :farmers, skip: [:password, :sessions],
              :controllers => {:registrations =>"registrations"}

  devise_for :agrofunders, skip: [:password, :sessions],
             :controllers => {:registrations =>"registrations"}

  #FARMER
  get "/farmer/:id" => "farmers#show", as: :farmer
  get "/farmer/:id/admin" =>"farmers#admin", as: :farmer_admin
  get "/farmer/:id/profile" =>"farmers#edit", as: :farmer_profile
  put "/farmer/:id" => "farmers#update"

  #AGROFUNDER
  get "/agrofunder/:id" => "agrofunders#show", as: :agrofunder
  get "/agrofunder/:id/admin" =>"agrofunders#admin", as: :agrofunder_admin
  get "/agrofunder/:id/profile" =>"agrofunders#edit", as: :agrofunder_profile
  put "/agrofunder/:id" => "agrofunders#update"

  #FARMLANDS
  get "/farmlands" => "farmlands#index", as: :farmlands_map
  get "/farmer/:id/farmland/new" => "farmlands#new", as: :farmer_farmland_new
  get "/farmer/:id/farmland/:farm_id" => "farmlands#show", as: :farmer_farmland
  post "/farmer/:id/farmland" => "farmlands#create", as: :farmer_farmlands
  
  #API
  get "/maps" => "maps#index"

  resources :subscriptions, except: :index

end
