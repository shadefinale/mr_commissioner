FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "Foo#{n}" }
    password                  "password"
    password_confirmation     "password"
  end

end
