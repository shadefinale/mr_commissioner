require 'rails_helper'

describe "leagues/show.html.erb" do

  it "should show 'league name' on the page" do
    render
    expect(rendered).to have_content("League Name")
  end
end
