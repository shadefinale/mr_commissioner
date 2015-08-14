require 'rails_helper'

RSpec.describe Week, type: :model do
  let(:week){create(:week)}

  context "attributes" do

    it "has a year" do
      expect(week.year).to eq(2015)
    end

    it "has a week number" do
      expect(week.number).to eq(1)
    end

  end
end
