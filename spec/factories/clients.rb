FactoryBot.define do
  factory :client do
    sequence(:name) { |n|  "Transportes ##{n}" }
    created_at { DateTime.now() }
    updated_at { DateTime.now() }
  end
end
