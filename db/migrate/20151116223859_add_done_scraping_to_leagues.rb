class AddDoneScrapingToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :done_scraping, :boolean, default: false
  end
end
