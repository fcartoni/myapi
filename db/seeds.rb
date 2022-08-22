# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).


10.times do |i|
    Client.create(name: "Client ##{i+1}")
  end

10.times do |i|
    Property.create(name: "address", value: "Calle #{i+1}", client_id: i+1)
    Property.create(name: "country", value: "Pais #{i+1}", client_id: i+1)
    Property.create(name: "postal code", value: "#{i+1}00000", client_id: i+1)
end