# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

League.destroy_all
Player.destroy_all
Team.destroy_all
PlayerScore.destroy_all
Week.destroy_all


2000.upto(2100).each do |year|
  1.upto(17).each do |week|
    Week.create(number: week, year: year)
  end
end

s = Scraper.new(143124, 2014)
s.scrape_all

