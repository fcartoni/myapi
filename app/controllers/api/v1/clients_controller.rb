class Api::V1::ClientsController < ApplicationController
  def index
    clients = Client.all
    response = []
    # For each client find their properties
    for client in clients do
      properties = Property.select(:name, :value, :type_value).where(client_id: client.id)
      properties_noid = []
      # Take out property's id to match doc
      for property in properties do
        value_official_type = transform_string_to_type(property["type_value"], property["value"])
        properties_noid.push({"name": property["name"], "value": value_official_type, "type": property["type_value"]})
      end
      # Build up each client and push to response
      client = {"id": client.id, "name": client.name, "properties": properties_noid}
      response.push(client)
    end
    # Return response
    render json: {clients: response}
  end

  def create
    client = Client.new(name: client_params[:name])
    # Try to save client
    if client.save
      render json: client
    else
      render json: {error: client.errors.objects.first.full_message}
    end

  end 

  def show 
    # Query to find properties of the client
    info = Property.joins(:client)
                      .select("client.name as client_name,
                              properties.id, properties.name,
                              properties.value, properties.type_value")
                      .where('client.id' => params[:id]) 
    if info != []
      # Build properties array
      properties = []
      client_name = info[0]["client_name"]
      for property in info do
        puts "helpoooo"
        puts property["type_value"]
        value_official_type = transform_string_to_type(property["type_value"], property["value"])
        properties.push({"id": property["id"], "name": property["name"], "value": value_official_type, "type": property["type_value"]})
      end
      # Build response
      response = {"id": params[:id], "name": client_name, "properties": properties}
      render json: response
    else
      render json: {error: "No client with id #{params[:id]}"}
    end
  end

  def update
    client = find_client
    # Verify client's existence
    if client
      # Try to update
      if client.update(name: client_params[:name])
        render json: {message: "Client updated successfully!"}
      else
        render json: {error: client.errors.objects.first.full_message}
      end
    else
      render json: {error: "No client with id #{params[:id]}"}
    end
  end

  def destroy
    client = find_client
    # Verify client's existence
    if client
      # Try to delete
      if client.destroy
        render json: {message: "Client deleted successfully"}
      else
        render json: {error: client.errors.objects.first.full_message}
      end
    else
      render json: {error: "No client with id #{params[:id]}"}
    end
  end

private
  def client_params
    params.require(:client).permit([
      :name
    ])
  end

  def find_client
    Client.find_by(id: params[:id])
  end

  def transform_string_to_type(type, value)
    if type == "string"
      new_value = value.to_s
    elsif type == "integer"
      new_value = value.to_i
    elsif type == "boolean"
      if type == "true"
        new_value = true
      else
        new_value = false
      end
    end
    return new_value
  end

end

