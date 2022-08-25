# README

## Información relevante

* Ruby version: 3.1.2
* Rails version: 7.0.3.1
* PostgreSQL version: 14.5

## Development Setup

1. Clonar repositorio: git clone https://github.com/fcartoni/myapi.git
2. Entrar a la carpeta: cd myapi 
3. Instalar dependencias: bundle install
4. Crear base de datos: rails db:create
5. Correr migraciones: rails db:migrate
6. Poblar base de datos: rails db:seed
7. Correr la API: rails s
8. Listo! Ya se pueden mandar requests (ver documentaciones más abajo)

## Run tests:

* Controllers tests: 
    * Clients: rspec ./spec/controllers/clients_controllers_spec.rb
    * Properties: rspec ./spec/controllers/properties_controllers_spec.rb
* Routing tests: rspec ./spec/routing/routing_spec.rb

## Documentación:

* Clients: https://documenter.getpostman.com/view/22915904/VUqrPHfP
* Properties: https://documenter.getpostman.com/view/22915904/VUqpvJSk

