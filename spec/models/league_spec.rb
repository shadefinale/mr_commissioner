require 'rails_helper'

RSpec.describe League, type: :model do
  let(:roster_count){create(:roster_count)}
  let(:league){roster_count.league}
  let(:team){create(:team)}

  context "associations" do

    it "should respond to teams association" do
      expect(league).to respond_to(:teams)
    end

    it "should have roster counts" do
      expect(league).to respond_to(:roster_counts)
    end

  end

  context "attributes" do

    it "has a name" do
      expect(league.name).to eq("foo")
    end

    it "has qb count" do
      expect(league.qb_count).to eq(1)
    end

    it "has rb count" do
      expect(league.rb_count).to eq(2)
    end

    it "has wr count" do
      expect(league.wr_count).to eq(2)
    end

    it "has te count" do
      expect(league.te_count).to eq(1)
    end

    it "has k count" do
      expect(league.k_count).to eq(1)
    end

    it "has d_st count" do
      expect(league.d_st_count).to eq(1)
    end

    it "has lb count" do
      expect(league.lb_count).to eq(0)
    end

    it "has dl count" do
      expect(league.dl_count).to eq(0)
    end

    it "has db count" do
      expect(league.db_count).to eq(0)
    end

    it "has flex count" do
      expect(league.flex_count).to eq(1)
    end

    it "has dt count" do
      expect(league.dt_count).to eq(0)
    end

    it "has de count" do
      expect(league.de_count).to eq(0)
    end

    it "has s count" do
      expect(league.s_count).to eq(0)
    end

    it "has cb count" do
      expect(league.cb_count).to eq(0)
    end

  end
end

