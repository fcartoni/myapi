class Api::V1::PropertiesController < ApplicationController
  def index
    properties = Property.select(:id, :client_id, :name, :value).all
    render json: {properties: properties}
  end

  def show
    property = find_property
    if find_property
      render json: property
    else
      render json: {error: "No property with id #{params[:id]}"}
    end

  end

  def create
    saved = []
    not_saved = []
    for p in params[:properties] do
      property = Property.new(name: p["name"],
                              value: p["value"],
                              client_id: properties_params[:client_id])   
      if property.save
        saved.push(p)
      elsif not find_client
        render json: {error: property.errors.objects.first.full_message }
        return
      else 
        errors = {p["name"] => property.errors.objects.first.full_message }
        not_saved.push(errors)
      end
    end

    if not_saved == []
      render json: {"properties": saved}
    else
      render json: {error: not_saved}
    end
  end

  def update
    # Only value update
    property = find_property
    if property
      if property.update(value: properties_params[:value])
        render json: {message: "Property's value updated successfully!"}
      else
        render json: {error: property.errors.objects.first.full_message}
      end
    else
      render json: {error: "No property with id #{params[:id]}"}
    end
  end

  def destroy
    # Destroy specific property by id
    property = find_property
    if property
      if property.destroy
        render json: {message: "Property deleted succesfully!"}
      else
        render json: {error: property.errors.objects.first.full_message}
      end
    else
      render json: {error: "No property with id #{params[:id]}"}
    end
  end


private

  def properties_params
    params.require(:property).permit([
      :client_id,
      :name,
      :value
    ])
  end

  def find_client
    Client.find_by(id: properties_params[:client_id])
  end

  def find_property
    Property.select(:id, :client_id, :name, :value).find_by(id: params[:id])
  end

end