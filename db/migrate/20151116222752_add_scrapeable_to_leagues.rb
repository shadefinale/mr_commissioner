class AddScrapeableToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :scrapeable, :boolean, default: true
  end
end
