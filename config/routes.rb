Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # get "api/v1/merchants/find", to: "merchants#find"

  namespace :api do 
    namespace :v1 do
      get "/merchants/find", to: "find#show"
      resources :merchants, only: [:index, :show] do
        resources :items, only: :index
      end
    end
  end

  namespace :api do
    namespace :v1 do 
      get "items/find_all", to:  "find_all#index"
      resources :items do
        get "/merchant", to: "merchants#show"
      end
    end
  end
end
