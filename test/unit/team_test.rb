require 'test_helper'

class TeamTest < ActiveSupport::TestCase

  def setup
    activate_authlogic
  end

  # NOTE:
  #  when testing Google Apps:
  #  1: do a .save when before minipulating fixtures
  #  2: do a .destroy on all objects that were saved

  def test_build_email
    domain = GOOGLE_DOMAIN
    course = Course.find(:first)
    record = Team.new(:name => 'RailsFixture Team A', :course_id => course.id)
    assert_equal(record.build_email, "fall-#{course.year}-railsfixture-team-a" + "@" + domain)
  rescue GDataError => e
    Rails.logger.debug("Skipping parts of this test case")
  end


  def test_google_apps_create_new_and_destroy
    #Clean up from a previous execution of a failed run of this test case
    google_apps_connection.delete_group("fall-2008-railsfixture-team-a")
  rescue GDataError => e

    course = Course.find(:first)
    record = nil
    assert_difference 'count_teams', 1 do
      assert_difference 'Team.count', 1 do
        record = Team.new(:name => 'RailsFixture Team A', :course_id => course.id)
        record.save
        #This next line is necessary since send_later delays -- maybe should be tested separately
        record.update_google_mailing_list(record.email, "nonexistant-email",  record.id)
      end
      wait_for_google_sync
    end
    assert_difference 'count_teams', -1 do
      assert_difference 'Team.count', -1 do
        record.destroy
      end
      wait_for_google_sync
    end
  rescue GDataError => e
    Rails.logger.debug("Skipping parts of this test case")
  end

#  ActiveRecord::MissingAttributeError: missing attribute: email on line 19 caused bye !new_team.save
#  def test_cannot_be_same_name
#    original_team = teams(:teamOne)
#    original_team.save
#
#    assert_no_difference 'count_teams' do
#      assert_no_difference 'Team.count' do
#        #clone original_team
#        new_team = Team.new
##        original_team.attributes.each {|attr, value| eval("new_team.#{attr}= original_team.#{attr}")}
#        new_team.email = original_team.email
#        assert !new_team.save, "Should not be able to save cloned team"
#      end
#      wait_for_google_sync
#    end
#    original_team.destroy
#    wait_for_google_sync
#  end


  def test_rename_team
    #Clean up from a previous execuction of a failed run of this test case
    old_group = "fall-2008-fixturedeming-teamone"
    renamed_group = "fall-2008-fixturedeming-teamone_renamed"
    google_apps_connection.retrieve_all_groups.each do |list|
      group_name = list.group_id.split('@')[0]
      google_apps_connection.delete_group(old_group) if old_group == group_name
      google_apps_connection.delete_group(renamed_group) if renamed_group == group_name
    end

    team = teams(:teamOne)
    team.save
    assert_no_difference 'count_teams', 0 do
      assert_no_difference 'Team.count', 0 do
        team.update_attributes({:name => "#{team.name}_renamed"})
      end
      wait_for_google_sync
    end
    team.destroy
    wait_for_google_sync
  rescue GDataError => e
    Rails.logger.debug("Skipping parts of this test case")
  end

  def test_proper_email
    course = Course.find(:first)
    record = Team.new(:name => 'RailsFixture Deming Team A', :course_id => course.id)
    record.save
    expected_email = "#{course.semester}-#{course.year}-#{record.name}@#{GOOGLE_DOMAIN}".chomp.downcase.gsub(/ /, '-')
    assert_equal record.email, expected_email, "Unexpected email value"
    record.destroy
    wait_for_google_sync
  rescue GDataError => e
    Rails.logger.debug("Skipping parts of this test case")
  end

#This test started failing on 4/15/2011, need to refactor all of this code to mock out google api
#  def test_change_mailinglist
#    team = Team.find(:first)
#    team.save
#    #This next line is necessary since send_later delays
#    team.update_google_mailing_list(team.email, "nonexistant-email@sandbox.sv.cmu.edu",  team.id)
#    student = users(:student_sam)
#    assert_not_nil team, "team should not be nil"
#    assert_not_nil student, "student should not be nil"
#    #puts "DEBUG: #{team.name} consists of #{count_members(team.build_email)} members"
#    # add member
#    assert_difference 'count_members(team.build_email)', 1 do
#      team.add_person_by_human_name(student.human_name)
#      team.save
#      #This next line is necessary since send_later delays
#      team.update_google_mailing_list(team.email, team.email,  team.id)
#
#      wait_for_google_sync
#      #puts "DEBUG: #{team.name} consistes of #{count_members(team.build_email)} members"
#    end
#    # remove member
#    assert_difference 'count_members(team.build_email)', -1 do
#      team.remove_person(student.id)
#      wait_for_google_sync
#      #puts "DEBUG: #{team.name} consistes of #{count_members(team.build_email)} members"
#    end
#    #puts "DEBUG: handle bad name"
#    # handle bad name
#    assert_no_difference 'team.people.count' do
#      team.add_person_by_human_name("abc defg")
#    end
#    team.destroy
#    wait_for_google_sync
#  rescue GDataError => e
#    Rails.logger.debug("Skipping parts of this test case")
#  end

  private
  def count_teams
    google_apps_connection.retrieve_all_groups.size
  end
  def count_members(team_email)
    Rails.logger.debug "count_members#{team_email}"
    google_apps_connection.retrieve_all_members(team_email).size
  end
end
