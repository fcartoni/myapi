require 'rails_helper'

RSpec.describe "Api::PropertiesController", type: :request do
  
  # Success get all properties
  describe "GET /api/v1/properties" do

    it "gets all properties" do
      client = create(:client)
      property_1 = create(:property, client_id: client.id)
      property_2 = create(:property, client_id: client.id)
      
      expected_response = {
        "properties" => [{
          "id" => property_1.id,
          "client_id" => property_1.client_id,
          "name" => property_1.name,
          "value" => property_1.value,
          "type" => property_1.type_value
          },
          {
            "id" => property_2.id,
            "client_id" => property_2.client_id,
            "name" => property_2.name,
            "value" => property_2.value,
            "type" => property_2.type_value
            }]
      }

      get "/api/v1/properties"

      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Success get property by ID
  describe "GET /api/v1/property/:id" do

    it "gets property by ID" do
      client = create(:client)
      property = create(:property, client_id: client.id)
      
      expected_response = {
          "id" => property.id,
          "client_id" => property.client_id,
          "name" => property.name,
          "value" => property.value,
          "type" => property.type_value
    }
      get "/api/v1/property/#{property.id}"

      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end
  
  # Property not found => get property by ID
  describe "GET /api/v1/property/:id" do

    it "property not found when searching by ID" do
      # Create client and property and save property's ID
      client = create(:client)
      property = create(:property, client_id: client.id)
      property_id = property.id
      # Delete property
      body_request = {
          "client_id": client.id,
          "properties": [
              {
                  "name": property.name,
                  "value": property.value,
                  "type": property.type_value
              }
          ]
      }
      delete "/api/v1/properties" , :params => body_request

      expected_response = {
        "error" => "No property with id #{property_id}"
      }
      # Tries to find property, should not find it
      get "/api/v1/property/#{property_id}"

      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Success create properties
  describe "POST /api/v1/properties" do

    it "creates property" do
      # Create property
      client = create(:client)
      body_request = {
        "client_id": client.id,
        "properties": [
            {
                "name": "Example name 1",
                "value": "Example value 1",
                "type": "string"
            },
            {
                "name": "Example name 2",
                "value": true,
                "type": "boolean"
            }
        ]}
      post "/api/v1/properties", :params => body_request, as: :json

      expected_response = {
        "properties" => [
            {
                "name" => "Example name 1",
                "value" => "Example value 1",
                "type" => "string"
            },
            {
                "name" => "Example name 2",
                "value" => true,
                "type" => "boolean"
            }
        ]
      }
      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Client not found => create properties
  describe "POST /api/v1/properties" do

    it "client not found when creating property" do
      # Create client
      client = create(:client)
      client_id = client.id
      # Delete client
      delete "/api/v1/client/#{client_id}"

      body_request = {
        "client_id": client_id,
        "properties": [
            {
                "name": "Example name 1",
                "value": "Example value 1",
                "type": "string"
            }
        ]}
      post "/api/v1/properties", :params => body_request

      expected_response = { "error" => "Client must exist" }
      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Repeated property => create properties
  describe "POST /api/v1/properties" do

    it "repeated property when creating one" do
      # Create client
      client = create(:client)
      # Create property
      property = create(:property, client_id: client.id)
      # Try to create property with same name
      body_request = {
        "client_id": client.id,
        "properties": [
            {
                "name": property.name,
                "value": "Example value 1",
                "type": "string"
            }
        ]}
      post "/api/v1/properties", :params => body_request

      expected_response = { "error" => [
        {
            property.name => "Name of property has already been used for this Client. Try updating its value."
        }
    ]}
      expect(JSON.parse(response.body)).to include(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Invalid type
  describe "POST /api/v1/properties" do

    it "invalid type when creating property" do
      # Create property
      client = create(:client)
      body_request = {
        "client_id": client.id,
        "properties": [
            {
                "name": "Example float",
                "value": 3.4,
                "type": "float"
            }
        ]}
      post "/api/v1/properties", :params => body_request, as: :json

      expected_response = { "error" => [{ "Example float"=> "Type must be integer, boolean or string"}]
      }
      expect(JSON.parse(response.body)).to include(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Inconsistence type/value
  describe "POST /api/v1/properties" do

    it "detects inconsistency between type and value" do
      # Create property
      client = create(:client)
      body_request = {
        "client_id": client.id,
        "properties": [
            {
                "name": "Example name 1",
                "value": 1,
                "type": "boolean"
            }
        ]}
      post "/api/v1/properties", :params => body_request, as: :json

      expected_response = {"error" => [{"Example name 1"=> "Type is not consistent with value"}]}
          
      expect(JSON.parse(response.body)).to include(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Success edit properties
  describe "PUT /api/v1/properties" do

    it "edits properties" do
      client = create(:client)
      property_1 = create(:property, client_id: client.id)
      property_2 = create(:property, client_id: client.id)
      body_request = {
        "client_id": client.id,
        "properties": [
            {
                "name": property_1.name,
                "value": "Change value 1",
                "type": property_1.type_value
            },
            {
                "name": property_2.name,
                "value": "Change value 2",
                "type": property_2.type_value
            }
        ]
    }
      
      put "/api/v1/properties", :params => body_request
      expected_response = {
        "message" => "Properties updated successfully!",
        "properties" => [
            {
                "name" => property_1.name,
                "value" => "Change value 1",
                "type" => property_1.type_value
            },
             {
                "name" => property_2.name,
                "value" => "Change value 2",
                "type" => property_2.type_value
            }]}  

      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Client not found => edit properties
  describe "PUT /api/v1/properties" do

    it "client not found when editing property" do
      # Create client and property
      client = create(:client)
      client_id = client.id
      property = create(:property, client_id: client.id)
      # Delete client
      delete "/api/v1/client/#{client_id}"
      # Try editing property
      body_request = {
        "client_id": client_id,
        "properties": [
            {
                "name": property.name,
                "value": "Example value 1",
                "type": property.type_value
            }
        ]}
      put "/api/v1/properties", :params => body_request

      expected_response = { "error" => "No client with id #{client_id}" }
      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Property not found => edit properties
  describe "PUT /api/v1/properties" do

    it "property not found when editing property" do
      # Create client and property
      client = create(:client)
      property = create(:property, client_id: client.id)
      # Delete property
      body_request = {
        "client_id": client.id,
        "properties": [
            {
                "name": property.name,
                "value": property.value,
                "type": property.type_value
            }
        ]
    }
      delete "/api/v1/properties", :params => body_request
      # Try editing property
      body_request = {
        "client_id": client.id,
        "properties": [
            {
                "name": property.name,
                "value": "Example value 1",
                "type": property.type_value
            }
        ]}
      put "/api/v1/properties", :params => body_request

      expected_response = { "error" => "These properties could not be updated because they do not exist" }
      expect(JSON.parse(response.body)).to include(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Success delete properties
  describe "DELETE /api/v1/properties" do

    it "deletes properties" do
      client = create(:client)
      property_1 = create(:property, client_id: client.id)
      property_2 = create(:property, client_id: client.id)
      body_request = {
        "client_id": client.id,
        "properties": [
            {
                "name": property_1.name,
                "value": property_1.value,
                "type": property_1.type_value
            },
            {
                "name": property_2.name,
                "value": property_2.value,
                "type": property_2.type_value
            }
        ]
    }
      expected_response = {
        "message" => "Properties deleted successfully!",
        "properties" => [
            {
                "name" => property_1.name,
                "value" => property_1.value,
                "type" => property_1.type_value
            },
             {
                "name" => property_2.name,
                "value" => property_2.value,
                "type" => property_2.type_value
            }]}  
      
      delete "/api/v1/properties", :params => body_request


      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Client not found => delete properties
  describe "DELETE /api/v1/properties" do

    it "client not found when deleting property" do
      # Create client and property
      client = create(:client)
      client_id = client.id
      property = create(:property, client_id: client.id)
      # Delete client
      delete "/api/v1/client/#{client_id}"
      # Try deleting property
      body_request = {
        "client_id": client_id,
        "properties": [
            {
                "name": property.name,
                "value": property.value,
                "type": property.type_value
            }
        ]}
      delete "/api/v1/properties", :params => body_request

      expected_response = { "error" => "No client with id #{client_id}" }
      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(response).to have_http_status(200)
    end
  end

  # Property not found => delete properties
  describe "DELETE /api/v1/properties" do

    it "property not found when deleting property" do
      # Create client and property
      client = create(:client)
      property = create(:property, client_id: client.id)
      # Delete property
      body_request = {
        "client_id": client.id,
        "properties": [
            {
                "name": property.name,
                "value": property.value,
                "type": property.type_value
            }
        ]
    }
      delete "/api/v1/properties", :params => body_request
      # Try deleting property again
    
      delete "/api/v1/properties", :params => body_request

      expected_response = { "error" => "These properties could not be deleted because they do not exist." }
      expect(JSON.parse(response.body)).to include(expected_response)
      expect(response).to have_http_status(200)
    end
  end

end