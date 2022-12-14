class Client < ApplicationRecord
    has_many  :properties, dependent: :destroy
    
    validates :name, presence: true, uniqueness: true
end
