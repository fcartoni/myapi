class Api::V1::PropertiesController < ApplicationController
  def index
    properties = Property.select(:id, :client_id, :name, :value).all
    render json: {properties: properties}
  end

  def show
    property = find_property
    if property
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
    changed = []
    unchanged = []
    # Verify existence of client
    if find_client
      for p in params[:properties] do
        # Verify existence of property
        property = Property.where(name: p["name"], client_id: params[:client_id])
        if property != []
          # Try updating property
          if property.update(value: p["value"])
            changed.push(p)
          else
            unchanged.push(p)
          end
        else
          unchanged.push(p)
        end
      end
      if unchanged == []
        render json: {"message": "Properties updated successfully!",
                      "properties": changed}
      else
        render json: {"message": "These properties could not be updated because they do not exist.",
                      "properties": unchanged}
      end
    else
      render json: {error: "No client with id #{params[:client_id]}"}
    end
  end

  def destroy
    deleted = []
    not_deleted = []
    if find_client
      for p in params[:properties] do
        # Verify existence of property
        property = Property.where(name: p["name"], client_id: params[:client_id])
        if property != []
          # Try deleting it
          if property[0].destroy
            deleted.push(p)
          else
            not_deleted.push(p)
          end
        else
          not_deleted.push(p)
        end
      end
      if not_deleted == []
        render json: {"message": "Properties deleted successfully!",
                      "properties": deleted}
      else
        render json: {"message": "These properties could not be deleted because they do not exist.",
                      "properties": not_deleted}
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