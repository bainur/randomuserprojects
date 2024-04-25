Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # config/routes.rb
  resources :users, only: [:index]
  post '/users/:id', to: 'users#destroy'
  get 'total', to: 'reports#total'
end
