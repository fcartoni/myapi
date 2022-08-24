require 'rails_helper'

RSpec.describe "Api::ClientsController", type: :request do
  
  # Success get all clients
  describe "GET /api/v1/clients" do
    it "gets all clients" do
      client_1 = create(:client)
      client_2 = create(:client)
      property_1 = create(:property, client_id: client_1.id)
      property_2 = create(:property, client_id: client_2.id)
      
      expected_response = {
        "clients"=> [
            {
                "id" => client_1.id,
                "name" => client_1.name,
                "properties" => [
                    {
                        "name" => property_1.name,
                        "value" => property_1.value,
                        "type" => property_1.type_value
                    }
                ]
            },
            {
                "id" => client_2.id,
                "name" => client_2.name,
                "properties" => [
                    {
                        "name" => property_2.name,
                        "value" => property_2.value,
                        "type" => property_2.type_value
                    }
                ]
            }
        ]
    }

      get "/api/v1/clients"

      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Success get client by ID
  describe "GET /api/v1/client/:id" do

    it "gives details of client" do
      client = create(:client)
      property = create(:property, client_id: client.id)
      
      expected_response = {
        "id" => "#{client.id}",
        "name" => client.name,
        "properties" => [{
          "id" => property.id,
          "name" => property.name,
          "value" => property.value,
          "type" => property.type_value
          }]
      }
      get "/api/v1/client/#{client.id}"

      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Client not found => get client by ID
  describe "GET /api/v1/client/:id" do

    it "client not found when searching by ID" do
      # Create client and save her ID
      client = create(:client)
      client_id = client.id
      # Delete client
      delete "/api/v1/client/#{client_id}"

      expected_response = {
        "error" => "No client with id #{client_id}"
      }
      # Tries to find client, should not find it
      get "/api/v1/client/#{client_id}"

      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Success create client
  describe "POST /api/v1/client" do

    it "creates client" do
      
      post "/api/v1/client", :params => { :client => {:name => "Client test" }}

      expect(JSON.parse(response.body)).to include("name" => "Client test")
      expect(response).to have_http_status(200)
    end
  end

  # Blank name create client
  describe "POST /api/v1/client" do

    it "does not create client because of blank name" do
      
      post "/api/v1/client", :params => { :client => {:name => "" }}

      expect(JSON.parse(response.body)).to include("error" => "Name can't be blank")
      expect(response).to have_http_status(200)
    end
  end

  # Success edit client
  describe "PUT /api/v1/client/:id" do

    it "edits a client" do
      client = create(:client)
      
      put "/api/v1/client/#{client.id}", :params => { :client => {:name => "New name test" }}

      expect(JSON.parse(response.body)).to eq("message" => "Client updated successfully!")
      expect(response).to have_http_status(200)
    end
  end

  # Client not found when editing it
  describe "PUT /api/v1/client/:id" do

    it "client not found when editing" do
      # Create client and save her ID
      client = create(:client)
      client_id = client.id
      # Delete client
      delete "/api/v1/client/#{client_id}"

      expected_response = {
        "error" => "No client with id #{client_id}"
      }
      # Tries to find client, should not find it
      put "/api/v1/client/#{client_id}", :params => { :client => {:name => "New name test" }}

      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Name already used when editing it
  describe "PUT /api/v1/client/:id" do

    it "client not found when editing" do
      # Create two clients
      client_1 = create(:client)
      client_2 = create(:client)

      expected_response = {
        "error" => "Name has already been taken"
      }
      # Tries to put name of client_2 to client_1
      put "/api/v1/client/#{client_1.id}", :params => { :client => {:name => client_2.name }}

      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Success deleting client
  describe "DELETE /api/v1/client/:id" do

    it "deletes a client" do
      client = create(:client)
      
      delete "/api/v1/client/#{client.id}"

      expect(JSON.parse(response.body)).to eq("message" => "Client deleted successfully")
      expect(response).to have_http_status(200)
    end
  end

  # Client not found when deleting client
  describe "DELETE /api/v1/client/:id" do

    it "client not found when deleting a client" do
      client = create(:client)
      client_id = client.id
      # Deletes two times
      delete "/api/v1/client/#{client_id}"
      delete "/api/v1/client/#{client_id}"
      
      expected_response = {
        "error" => "No client with id #{client_id}"
      }

      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end
  
end