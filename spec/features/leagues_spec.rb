require 'rails_helper'

feature 'Viewing Dashboard' do

  # John Sportsfan wants to use our site!
  # He inputs a league ID and is taken to the dashboard for that league
  scenario 'showing the dashboard' do
    visit league_path(1)
    expect(page).to have_content('League Name')
    # John Sportsfan also expects the page to have a table on it.
    expect(page).to have_xpath("//table/tr/th[.='Statistic']")
    # John Sportsfan expects to see a row with column 'Best Player by Points.'
    expect(page).to have_xpath("//table/tr/td[.='Best Player by Points']")
  end
end
