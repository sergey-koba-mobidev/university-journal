FactoryBot.define do
  factory :attend do
    visit { nil }
    user { nil }
    mark { 1 }
    mark_ects { 1 }
    presence { 1 }
  end

end
