require 'spec_helper'

RSpec.feature "Visiting pages", :type => :feature do
  
  scenario "Visit root page" do
    visit "/"
    expect(page).to have_text("Rankings")
  end

  scenario "visit rankings page" do
    visit "/rankings"
    expect(page).to have_text("Rankings")
  end
  
  scenario "visit feed page" do
    visit "/feed"
    expect(page).to have_text("Latest Results")
  end

  scenario "visit faq page" do
    visit "/faq"
    expect(page).to have_text("FAQ page")
  end

  scenario "visit news page" do
    visit "/news"
    expect(page).to have_text("News")
  end


end