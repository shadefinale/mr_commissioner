require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:league){create(:league)}
  let(:team){create(:team)}

  context "associations" do

    it "should respond to league association" do
      expect(team).to respond_to(:league)
    end
  end

  context "attributes" do

    it "has a name" do
      expect(team.name).not_to be_nil
    end

    it "returns the score for the team of the given week"

  end

end
