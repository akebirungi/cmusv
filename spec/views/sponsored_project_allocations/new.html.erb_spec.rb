require 'spec_helper'

describe "sponsored_project_allocations/new" do

  before(:each) do
    assigns[:allocation] = stub_model(SponsoredProjectAllocation).as_new_record

    assigns[:projects] = [Factory.build(:sponsored_project)]
    assigns[:people] = [Factory.build(:faculty_frank), Factory.build(:admin_andy)]
  end

  it "renders new allocation form" do
    render

    response.should have_tag("form", :action => sponsored_project_allocations_path, :method => "post")
  end

  it "renders a list of projects to pick from" do
    #Todo , make this test more interesting in rails 3
    render

    response.should have_tag("select")
  end

  it "renders a list of people to pick from" do
    #Todo , make this test more interesting in rails 3
    render

    response.should have_tag("select")
  end

end