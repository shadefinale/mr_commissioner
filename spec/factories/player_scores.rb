FactoryGirl.define do
  factory :player_score do
    player
    week
    starter true
    points 110.0
    team
  end

end
