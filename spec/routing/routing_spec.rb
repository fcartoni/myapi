require 'rails_helper'

describe 'Routing', type: :routing do

    # get '/clients' => clients#index
    it do
        expect(:get => 'api/v1/clients').to route_to(
            :controller => "api/v1/clients",
            :action => "index"
        )
    end

    # get 'client/:id' => clients#show
    it do
        expect(:get => 'api/v1/client/:id').to route_to(
            :controller => "api/v1/clients",
            :action => "show",
            :id => ":id"
        )
    end

    # post '/client' => clients#create
    it do
        expect(:post => 'api/v1/client').to route_to(
            :controller => "api/v1/clients",
            :action => "create"
        )
    end

    # put '/client' => clients#update
    it do
        expect(:put => 'api/v1/client/:id').to route_to(
            :controller => "api/v1/clients",
            :action => "update",
            :id => ":id"
        )
    end

    # delete '/client' => clients#create
    it do
        expect(:delete => 'api/v1/client/:id').to route_to(
            :controller => "api/v1/clients",
            :action => "destroy",
            :id => ":id"
        )
    end

    # get '/properties' => properties#index
    it do
      expect(:get => 'api/v1/properties').to route_to(
          :controller => "api/v1/properties",
          :action => "index"
      )
    end

    # get '/property/:id' => properties#show
    it do
        expect(:get => 'api/v1/property/:id').to route_to(
            :controller => "api/v1/properties",
            :action => "show",
            :id => ":id"
        )
    end
    # post '/properties' => properties#create
    it do
        expect(:post => 'api/v1/properties').to route_to(
            :controller => "api/v1/properties",
            :action => "create"
        )
    end

    # put '/properties' => properties#update
    it do
        expect(:put => 'api/v1/properties').to route_to(
            :controller => "api/v1/properties",
            :action => "update"
        )
    end

    # delete '/properties' => properties#destroy
    it do
        expect(:delete => 'api/v1/properties').to route_to(
            :controller => "api/v1/properties",
            :action => "destroy"
        )
    end



end
