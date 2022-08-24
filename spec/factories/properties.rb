FactoryBot.define do
  factory :property do
    association :client, factory: :client
    sequence(:name) { |n|  "Property ##{n}" }
    sequence(:value) { |n|  "Value ##{n}" }
    type_value { "string" }
    created_at { DateTime.now() }
    updated_at { DateTime.now() }
  end
end
