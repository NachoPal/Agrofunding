Rails.application.routes.draw do
  
  get "/" => "sites#home", as: :root

  devise_for :users, skip: [:registration, :password],
              :controllers => {:sessions =>"sessions"}

  devise_for :farmers, skip: [:password, :sessions],
              :controllers => {:registrations =>"registrations"}

  devise_for :agrofunders, skip: [:password, :sessions],
             :controllers => {:registrations =>"registrations"}

  get "/farmer/:id" => "farmers#show", as: :farmer
  get "/farmer/:id/farmland/:farm_id" => "farmlands#show", as: :farmer_farmland
  get "/farmer/:id/admin" =>"farmers#admin", as: :farmer_admin
  get "/farmer/:id/profile" =>"farmers#edit", as: :farmer_profile
  put "/farmer/:id" => "farmers#update"
  get "/farmlands" => "farmlands#index", as: :farmlands_map

  get "/agrofunder/:id" => "agrofunders#show", as: :agrofunder
  get "/agrofunder/:id/admin" =>"agrofunders#admin", as: :agrofunder_admin
  get "/agrofunder/:id/profile" =>"agrofunders#edit", as: :agrofunder_profile
  put "/agrofunder/:id" => "agrofunders#update"

  get "/maps" => "maps#index"

  resources :subscriptions, except: :index

end
