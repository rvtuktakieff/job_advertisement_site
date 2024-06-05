Rails.application.routes.draw do
  resources :users

  resources :announcements, only: :create do
    get '/my', to: "announcements#my", on: :collection
    get '/active', to: "announcements#active", on: :collection
    post '/cancel', to: "announcements#cancel", on: :member
    
    resources :responses, only: :create do
      post '/accept', to: 'responses#accept', on: :member
      post '/cancel', to: 'responses#cancel', on: :member
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
