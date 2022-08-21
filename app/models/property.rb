class Property < ApplicationRecord
    belongs_to :client

    validates :name, presence: true, uniqueness: { scope: :client_id, message: 'of property has already been taken for this Client. Try updating its value.'}
    validates :value, :client_id, presence: true

end
