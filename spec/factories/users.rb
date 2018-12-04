FactoryBot.define do
  factory :user do
    confirmed_at Time.now
    name "Test User"
    email "admin@journal.com"
    password "12345678"

    trait :admin do
      role 'admin'
    end

  end
end
