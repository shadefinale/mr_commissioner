FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "Foo#{n}" }
    sequence(:email)    { |n| "Foo#{n}@email.com"}
    password                  "password"
    password_confirmation     "password"
  end

end
