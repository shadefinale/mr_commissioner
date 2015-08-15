FactoryGirl.define do
  factory :player_score do
    player
    week
    starter :true
    points 100.0
    team
  end

end
