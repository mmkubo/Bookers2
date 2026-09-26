Rails.application.routes.draw do
  
  root to: "homes#top"
  get "home/about" => "homes#about", as: "about"
  get "search", to: "searches#search"

  resources :users, only: [:new, :create, :index, :show, :edit, :update, :destroy], path_names: { new: "sign_up" } do
    resource :relationship, only: [:create, :destroy]
    member do 
      get :following
      get :followers
    end
  end

  resource :session
  resources :passwords, param: :token

  resources :books, only: [:create, :index ,:show, :edit, :update, :destroy] do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
