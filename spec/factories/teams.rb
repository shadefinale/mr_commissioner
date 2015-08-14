FactoryGirl.define do
  factory :team do
    sequence(:name){|n| "bars#{n}" }
    league
  end

end
