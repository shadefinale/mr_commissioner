require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:league) { create(:league) }
  let(:player_score) { create(:player_score) }
  let(:team) { player_score.team }

  context 'associations' do
    it 'should respond to league association' do
      expect(team).to respond_to(:league)
    end
  end

  context 'attributes' do
    it 'has a name' do
      expect(team.name).not_to be_nil
    end

    it 'returns the score for the team of the given week' do
      expect(team.weekly_scores(1, 2015)).to eq(110.0)
    end

    it 'shows the sum of all scores in a given season'
  end
end
