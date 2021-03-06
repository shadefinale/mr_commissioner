require 'rails_helper'

describe Scraper do
  describe '#initialize' do
    it 'requires a league id in its initializer' do
      expect { Scraper.new }.to raise_error(ArgumentError)
    end

    it 'accepts integer for league id in its initializer' do
      expect { Scraper.new(143_124) }.not_to raise_error
    end

    it 'accepts string of digits and sets its league_id in its initializer' do
      expect { Scraper.new('143124') }.not_to raise_error
    end

    it 'does not accept string with non-digits league_id in its initializer' do
      expect { Scraper.new('143a124') }.to raise_error
    end


    it 'should say league 143124 has 12 teams' do
      s = Scraper.new(143_124)
      allow(s).to receive(:get_points) { true }
      s.scrape_all
      expect(s.team_count).to eq(12)
    end
  end

  describe '#base_page' do
    it 'returns the proper base page for a given league and season' do
      heinbeil_league_scraper = Scraper.new(143_124, 2014)
      expect(heinbeil_league_scraper.base_page)
        .to eq(
          'http://games.espn.go.com/ffl/leagueoffice?leagueId=143124&seasonId=2014'
        )
    end

    it 'defaults to the current year if no season provided' do
      heinbeil_league_scraper = Scraper.new(143_124)
      expect(heinbeil_league_scraper.base_page)
        .to eq(
          'http://games.espn.go.com/ffl/leagueoffice?leagueId=143124&seasonId='\
          "#{DateTime.now.year}"
        )
    end
  end

  xdescribe '#settings_page' do

    it "should find the right league name" do
      heinbeil_league_scraper = Scraper.new(143_124)
      expect(heinbeil_league_scraper.league_name)
        .to eq('Heinbail Dynasty League')
    end

    it "should find the qb count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.qb_count)
        .to eq(1)
    end

    it "should find the rb count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.qb_count)
        .to eq(1)
    end

    it "should find the dt count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.dt_count)
        .to eq(0)
    end

    it "should find the wr count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.wr_count)
        .to eq(2)
    end

    it "should find the te count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.te_count)
        .to eq(1)
    end

    it "should find the de count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.de_count)
        .to eq(0)
    end

    it "should find the lb count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.lb_count)
        .to eq(0)
    end

    it "should find the dl count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.dl_count)
        .to eq(0)
    end

    it "should find the cb count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.cb_count)
        .to eq(0)
    end

    it "should find the s count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.s_count)
        .to eq(0)
    end

    it "should find the db count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.db_count)
        .to eq(0)
    end

    it "should find the kicker count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.k_count)
        .to eq(1)
    end

    it "should find the kicker count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.d_st_count)
        .to eq(1)
    end

    it "should find the flex count" do
      heinbeil_league_scraper = Scraper.new(123_123)
      expect(heinbeil_league_scraper.flex_count)
        .to eq(1)
    end
  end

  describe "player scores" do

  end
end
