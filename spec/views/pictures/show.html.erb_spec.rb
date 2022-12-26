require 'rails_helper'

RSpec.describe "pictures/show", type: :view do
  before(:each) do
    assign(:picture, Picture.create!(
      name: "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
