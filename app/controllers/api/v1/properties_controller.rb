class Api::V1::PropertiesController < ApplicationController
  def index
    properties = Property.select(:id, :client_id, :name, :value, :type_value).all
    response = []
    for property in properties do
      value_official_type = transform_string_to_type(property["type_value"], property["value"])
      response.push({
        "id": property["id"],
        "client_id": property["client_id"],
        "name": property["name"],
        "value": value_official_type,
        "type": property["type_value"]
    })
    end

    render json: {properties: response}
  end

  def show
    property = find_property
    # Verify property's existence
    if property
      # Change value to official type to show it
      value_official_type = transform_string_to_type(property["type_value"], property["value"])
      response = {
        "id": property["id"],
        "client_id": property["client_id"],
        "name": property["name"],
        "value": value_official_type,
        "type": property["type_value"]
    }
      render json: response
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
      # Verify valid type
      if ["string", "integer", "boolean"].include? property["type"]
        # Verify consistence between type and value
        if consistence_type_value(property["type"], property["value"])
          new_property = Property.new(name: property["name"],
                                  value: property["value"].to_s,
                                  client_id: params[:client_id],
                                  type_value: property["type"])   
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
        else 
          not_saved.push({property["name"] => "Type is not consistent with value"})
        end

      else
        not_saved.push({property["name"] => "Type must be integer, boolean or string"})
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
        found_property = Property.where(name: property["name"],
                                        client_id: params[:client_id],
                                        type_value: property["type"])
        if found_property != []
          # Try updating property
          new_value = property["value"].to_s
          if found_property.update(value: new_value)
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
        render json: {"error": "These properties could not be updated because they do not exist",
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
        found_property = Property.where(name: property["name"], client_id: params[:client_id], type_value: property["type"])
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
    params.require(:properties).permit([
      :client_id,
      { properties: [:name, :value] }
    ])
  end

  def find_client
    Client.find_by(id: params[:client_id])
  end

  def find_property
    Property.select(:id, :client_id, :name, :value, :type_value).find_by(id: params[:id])
  end

  def consistence_type_value(type, value)
    dict = {'string': String, 'integer': Integer}
    if type == "boolean"
      if value.class == TrueClass || value.class == FalseClass
        return true
      else
        return false
      end
    elsif type == "integer" && value.class == Integer
      return true
    elsif type == "string" && value.class == String
      return true
    else
      return false
    end
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