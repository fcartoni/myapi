class AddTypeToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :type_value, :string
  end
end
