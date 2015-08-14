require 'rails_helper'

feature 'Viewing Dashboard' do

  # John Sportsfan wants to use our site!
  # He inputs a league ID and is taken to the dashboard for that league
  scenario 'showing the dashboard' do
    visit league_path(1)
    expect(page).to have_content('League Name')
  end
end
