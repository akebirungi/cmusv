require 'spec_helper'

describe "pages/edit.html.erb" do
  before(:each) do
    UserSession.create(Factory(:faculty_frank))
    @page = assigns[:page] = stub_model(Page,
        :url => "something",
      :new_record? => false
    )
    assigns[:courses] =  [
      stub_model(Course),
      stub_model(Course)
    ]    
#rspec 2
#    @page = assign(:page, stub_model(Page,
#      :new_record? => false
#    ))
  end

  it "renders the edit page form" do
    render

    response.should have_tag("form", :action => page_path(@page), :method => "post")
#rspec 2
#    rendered.should have_selector("form", :action => page_path(@page), :method => "post")
  end
end
