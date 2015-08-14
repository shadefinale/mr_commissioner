require 'rails_helper'

describe "leagues/show.html.erb" do

  it "should show 'league name' on the page" do
    render
    expect(rendered).to have_content("League Name")
  end

  it "should have a table on the page" do
    render
    expect(rendered).to have_selector("table")
  end

  it "should have a table header row with 'statistic' in it" do
    render
    expect(rendered).to have_xpath("//table/tr/th[.='Statistic']")
  end

  it "should have a table row with 'best player by points' in it" do
    render
    expect(rendered).to have_xpath(
                        "//table/tr/td[.='Best Player by Points']")
  end
end

