require 'spec_helper'

describe CourseMailer do
  before(:each) do
    activate_authlogic
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end
  it "should send IT email" do
    course = Factory(:course, :configure_course_twiki => true)
    mail = CourseMailer.deliver_configure_course_admin_email(course)
    ActionMailer::Base.deliveries.size.should == 1
    mail.body.should =~ Regexp.new(course.name)
    mail.subject.should =~ Regexp.new(course.name)
  end

  it "should send faculty email" do
    course = Factory(:course, :configure_course_twiki => true)
    mail = CourseMailer.deliver_configure_course_faculty_email(course)
    ActionMailer::Base.deliveries.size.should == 1
    mail.body.should =~ Regexp.new(course.name)
    mail.subject.should =~ Regexp.new(course.name)
  end

end