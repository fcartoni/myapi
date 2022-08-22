Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Properties
      get 'properties', to: 'properties#index' 
      get 'property/:id', to: 'properties#show'
      post 'properties', to: 'properties#create'
      put 'properties', to: 'properties#update'
      delete 'properties', to: 'properties#destroy'
      
      # Clients
      get 'clients', to: 'clients#index'
      get 'client/:id', to: 'clients#show'
      post 'client', to: 'clients#create'
      put 'client/:id', to: 'clients#update'
      delete 'client/:id', to: 'clients#destroy'

    end
  end

end
