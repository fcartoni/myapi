class Api::V1::ClientsController < ApplicationController
  def index
    clients = Client.all
    response = []
    # For each client find their properties
    for c in clients do
      properties = Property.select(:name, :value).where(client_id: c.id)
      properties_noid = []
      # Take out property's id to match doc
      for p in properties do
        properties_noid.push({"name": p["name"], "value": p["value"]})
      end
      # Build up each client and push to response
      client = {"id": c.id, "name": c.name, "properties": properties_noid}
      response.push(client)
    end
    # Return response
    render json: {clients: response}
  end

  def create
    client = Client.new(name: client_params[:name])
      
    if client.save
      render json: client
    else
      render json: {error: client.errors.objects.first.full_message}
    end

  end 

  def show #MOSTRAR SUS PROPERTIES
    client = Client.select(:id, :name).find_by(id: params[:id])
    if client
      render json: client
    else
      render json: {error: "No client with id #{params[:id]}"}
    end
  end

  def update
    client = find_client
    if client
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
    if client
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
end

