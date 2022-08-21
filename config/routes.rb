Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Properties
      get 'properties', to: 'properties#index'
      get 'property/:id', to: 'properties#show'
      post 'properties', to: 'properties#create'
      put 'property/:id', to: 'properties#update'
      delete 'property/:id', to: 'properties#destroy'
      #delete 'properties/:client_id', to: 'properties#destroy'
      
      # Clients
      get 'clients', to: 'clients#index'
      get 'client/:id', to: 'clients#show'
      post 'client', to: 'clients#create'
      put 'client/:id', to: 'clients#update'
      delete 'client/:id', to: 'clients#destroy'

      # Nested
      #get 'client/:id/property/:id', to: ''
      #get 'client/:id/properties', to: ''
      #put 'client/:id/property/:id', to: ''
      #delete 'client/:id/property/:id', to: ''
      #delete 'client/:id/properties', to: ''
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
