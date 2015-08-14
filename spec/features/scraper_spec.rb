require 'rails_helper'

feature 'Scraping ESPN' do
  scenario 'should be able to scrape a league from espn' do
    espn_scraper = Scraper.new(143124)
    expect(espn_scraper).to be_a(Scraper)

  end
end
