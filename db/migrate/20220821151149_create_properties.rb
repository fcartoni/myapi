class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.string :name
      t.text :value
      t.integer :client_id
      
      t.timestamps
    end
  end
end
