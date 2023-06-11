require "rails_helper"

describe "Admin Merchant Show" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")
    visit admin_merchant_path(@m1)
  end

  it "should have merchant name" do
    expect(page).to have_content(@m1.name)
  end

  it "should have a link to update merchant" do
    expect(page).to have_link("Update Merchant")

    click_link "Update Merchant"

    expect(current_path).to eq(edit_admin_merchant_path(@m1))
  end

  it "should display updated information" do
    visit edit_admin_merchant_path(@m1)

    fill_in "merchant[name]", with: "Dang Boiii"

    click_button

    expect(current_path).to eq(admin_merchant_path(@m1))
    expect(page).to have_content("Dang Boiii")
  end

# 1b. Merchant Coupons Index on admin/merchant
  it "has a link to my coupons index page" do
    expect(page).to have_link("View Merchant's Coupons")
    click_link("View Merchant's Coupons")
    expect(current_path).to eq("/merchants/#{@m1.id}/coupons")
  end
end
