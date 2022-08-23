FactoryBot.define do
  factory :property do
    association :client, factory: :client
    sequence(:name) { |n|  "Property ##{n}" }
    sequence(:value) { |n|  "Value ##{n}" }
    created_at { DateTime.now() }
    updated_at { DateTime.now() }
  end
end
