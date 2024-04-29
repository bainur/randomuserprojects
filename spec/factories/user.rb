FactoryBot.define do
    factory :user do        
      sequence(:uuid) { |n| "uuid#{n}" }
      gender { 'male' }
      # Other attributes as needed
    end
end
  