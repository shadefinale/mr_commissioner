FactoryGirl.define do

  factory :player do
    sequence(:name){|n| "Bar Dude#{n}"}
    position :qb

  end

end
