require 'spec_helper'

describe "sponsored_project_sponsors/edit.html.erb" do
  before(:each) do
    @sponsor = assigns[:sponsor] = stub_model(SponsoredProjectSponsor, :new_record? => false)
  end

  it "renders edit sponsor form" do
    render

    response.should have_tag("form", :action => sponsored_project_sponsors_path(@sponsor), :method => "post")

  end
end
