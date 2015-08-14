require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:player){create(:player)}

  context "attributes" do
    it "has a name" do
      expect(player.name).not_to be_nil
    end

    it "has a position" do
      expect(player.position).to eq("qb")
    end
  end
end