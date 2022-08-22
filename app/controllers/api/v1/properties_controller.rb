class Api::V1::PropertiesController < ApplicationController
  def index
    properties = Property.select(:id, :client_id, :name, :value).all
    render json: {properties: properties}
  end

  def show
    property = find_property
    # Verify property's existence
    if property
      render json: property
    else
      render json: {error: "No property with id #{params[:id]}"}
    end

  end

  def create
    saved = []
    not_saved = []
    # Create and save each property
    for property in params[:properties] do
      # Create property
      new_property = Property.new(name: property["name"],
                              value: property["value"],
                              client_id: properties_params[:client_id])   
      # Try to save property
      if new_property.save
        saved.push(property)
      # Verify client's existence
      elsif not find_client
        render json: {error: new_property.errors.objects.first.full_message }
        return
      # Error saving property: duplicates, etc.
      else 
        errors = {property["name"] => new_property.errors.objects.first.full_message }
        not_saved.push(errors)
      end
    end

    if not_saved == []
      render json: {"properties": saved}
    else
      render json:{"error": not_saved,
                    "saved properties": saved}
    end
  end

  def update
    changed = []
    unchanged = []
    # Verify existence of client
    if find_client
      for property in params[:properties] do
        # Verify existence of property
        found_property = Property.where(name: property["name"], client_id: params[:client_id])
        if found_property != []
          # Try updating property
          if found_property.update(value: property["value"])
            changed.push(property)
          else
            unchanged.push(property)
          end
        else
          unchanged.push(property)
        end
      end
      if unchanged == []
        render json: {"message": "Properties updated successfully!",
                      "properties": changed}
      else
        render json: {"error": "These properties could not be updated because they do not exist.",
                      "properties": unchanged,
                    "updated properties": changed}
      end
    else
      render json: {error: "No client with id #{params[:client_id]}"}
    end
  end

  def destroy
    deleted = []
    not_deleted = []
    # Verify existence of client
    if find_client
      for property in params[:properties] do
        # Verify existence of property
        found_property = Property.where(name: property["name"], client_id: params[:client_id])
        if found_property != []
          # Try deleting it
          if found_property[0].destroy
            deleted.push(property)
          else
            not_deleted.push(property)
          end
        else
          not_deleted.push(property)
        end
      end
      if not_deleted == []
        render json: {"message": "Properties deleted successfully!",
                      "properties": deleted}
      else
        render json: {"error": "These properties could not be deleted because they do not exist.",
                      "properties": not_deleted,
                      "deleted properties": deleted}
      end
    else
      render json: {error: "No client with id #{params[:client_id]}"}
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
    Client.find_by(id: params[:client_id])
  end

  def find_property
    Property.select(:id, :client_id, :name, :value).find_by(id: params[:id])
  end

end