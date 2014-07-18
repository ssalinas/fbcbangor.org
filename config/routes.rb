Rails.application.routes.draw do
  # general site paths
  get '/about', to: 'pages#about', as: :about
  get '/directions', to: 'pages#directions', as: :directions
  get '/contact', to: 'pages#contact', as: :contact

  # paths for fullcalendar
  resources :events do
    collection do
      get :get_events
    end
    member do
      post :move
      post :resize
    end
  end

  # routes for admin views
  get '/admin', to: 'admin#home', as: :admin_home
  resources :announcements
  resources :carousel_images
  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'registrations#update', :as => 'user_registration'
    get '/signup', to: 'registrations#new', as: :new_user_registration
    post 'users', to: 'registrations#create', as: :user_registraion
    delete 'users', to: 'registrations#destroy'
  end

  # root path
  root to: 'pages#home'
end
