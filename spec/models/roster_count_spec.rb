require 'rails_helper'

RSpec.describe RosterCount, type: :model do
  let(:league){create(:league)}
  let(:roster_count){create(:roster_count)}

  context "associations" do

  end

  context "attributes" do

    it "has qb count" do
      expect(roster_count.qb).to eq(1)
    end

    it "has rb count" do
      expect(roster_count.rb).to eq(2)
    end

    it "has wr count" do
      expect(roster_count.wr).to eq(2)
    end

    it "has te count" do
      expect(roster_count.te).to eq(1)
    end

    it "has k count" do
      expect(roster_count.k).to eq(1)
    end

    it "has d_st count" do
      expect(roster_count.d_st).to eq(1)
    end

    it "has lb count" do
      expect(roster_count.lb).to eq(0)
    end

    it "has dl count" do
      expect(roster_count.dl).to eq(0)
    end

    it "has db count" do
      expect(roster_count.db).to eq(0)
    end

    it "has flex count" do
      expect(roster_count.flex).to eq(1)
    end

    it "has de count" do
      expect(roster_count.de).to eq(0)
    end

    it "has dt count" do
      expect(roster_count.dt).to eq(0)
    end

    it "has cb count" do
      expect(roster_count.cb).to eq(0)
    end

    it "has s count" do
      expect(roster_count.s).to eq(0)
    end


  end
end

