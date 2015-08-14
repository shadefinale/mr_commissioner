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

  describe '#settings_page' do
    it 'gives the settings page for the given league' do
      heinbeil_league_scraper = Scraper.new(143_124)
      expect(heinbeil_league_scraper.settings_page)
        .to eq(
          'http://games.espn.go.com/ffl/leaguesetup/settings?leagueId=143124'
        )
    end
  end
end
