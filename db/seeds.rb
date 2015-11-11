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

s = Scraper.new(143_124, 2015)
s.scrape_all
s = Scraper.new(143_424, 2015)
s.scrape_all
s = Scraper.new(332_312, 2015)
s.scrape_all
