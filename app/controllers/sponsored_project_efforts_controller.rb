class SponsoredProjectEffortsController < ApplicationController

  before_filter :require_user

  layout "cmu_sv"

  def index
#    if has_permissions_or_redirect(:admin, root_url)
      @month = params[:date][:month].to_i unless params[:date].nil?
      @month = @month ||= 1.month.ago.month
      @year = params[:year] ||= 1.month.ago.year
      @efforts = SponsoredProjectEffort.for_all_users_for_a_given_month(@month, @year)
 #   end
  end

  def show
    redirect_to(edit_sponsored_project_effort_path)
  end

  def edit
    setup_edit
  end

  def update
    effort_id_values = params[:effort_id_values]

    @failed = false
    @changed_allocation = false
    effort_id_values.each do |key,value|
      effort = SponsoredProjectEffort.find(key)
#      @changed_allocation = true if effort.actual_allocation != value
      effort.actual_allocation = value                    
      @changed_allocation = true if effort.actual_allocation_changed?
      effort.confirmed = true
      unless effort.save
        @failed = true
      end
    end
    if @changed_allocation
      SponsoredProjectEffort.emails_business_manager(effort_id_values.keys[0])
    end

    if @failed
      flash.now[:error] = 'Your allocations did not save.'
    else
      flash.now[:notice] = 'Your allocations are confirmed.'
    end

    setup_edit
    render 'edit'
  end

private
  def setup_edit
      @person = Person.find_by_twiki_name(params[:id])
      if (@person.nil?)
        flash[:error] = t(:no_person)
        redirect_to(root_url)
        return false
      end

      if @person.id == @current_user.id || @current_user.is_admin
        @efforts = SponsoredProjectEffort.month_under_inspection_for_a_given_user(@person.id)
        @month = !@efforts.empty? ? @efforts[0].month : 1.month.ago.month
        @year = !@efforts.empty? ? @efforts[0].year : 1.month.ago.year
      else
        flash[:error] = t(:no_permission)
        redirect_to(root_url)
        return false
      end
  end

end

