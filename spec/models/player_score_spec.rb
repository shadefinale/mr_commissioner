require 'rails_helper'

RSpec.describe PlayerScore, type: :model do

  let(:player_score){create(:player_score)}
  let(:week){player_score.week}
  let(:team){player_score.team}
  let(:player){player_score.player}

  context "assosciations" do

    it "has a player" do
      expect(player_score).to respond_to(:player)
    end

    it "has a week" do
      expect(player_score).to respond_to(:week)
    end

    it "has a team" do
      expect(player_score).to respond_to(:team)
    end

    it "has a league" do
      expect(player_score).to respond_to(:league)
    end

  end
end
