# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    user_id 1
    to_user_id 1
    body "MyText"
    is_viewed false
  end
end
