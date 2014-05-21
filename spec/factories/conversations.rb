# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :conversation do
    user_id 1
    to_user_id 1
    last_message_id 1
    is_viewed false
  end
end
