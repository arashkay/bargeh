# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    user_id 1
    body "MyText"
    latitude "9.99"
    longitude "9.99"
  end
end
