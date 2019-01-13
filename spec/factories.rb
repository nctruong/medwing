FactoryBot.define do
  factory :worker_message do
    worker { "MyString" }
    message { "MyString" }
    error { "" }
  end
  factory :reading do
    temperature { 30.2 }
    humidity { 50 }
    battery_charge { 33.2 }
    thermostat_id { 1 }
  end

  factory :thermostat do
    location { Faker::Address.city }
  end
end