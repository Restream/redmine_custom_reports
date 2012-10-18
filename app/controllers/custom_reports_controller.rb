class CustomReportsController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id
  before_filter :authorize
  before_filter :find_custom_reports, :only => [:index, :show, :new, :edit]
  before_filter :find_custom_report, :only => [:show, :edit, :update, :destroy]
  before_filter :authorize_to_manage, :only => [:edit, :update, :destroy]

  helper :queries
  include QueriesHelper

  def index
  end

  def show
    respond_to do |format|
      format.html
      format.json { Rabl::Renderer.json(@custom_report, 'custom_reports/show') }
    end
  end

  def new
    @custom_report = @project.custom_reports.build
  end

  def create
    @custom_report = @project.custom_reports.build(params[:custom_report])
    @custom_report.user = User.current
    @custom_report.is_public = false unless User.current.allowed_to?(:manage_public_custom_reports, @project) || User.current.admin?

    grab_filters_from_params(@custom_report)

    if @custom_report.save
      redirect_to url_for(
          :controller => "custom_reports",
          :action => "show", :project_id => @project, :id => @custom_report.id),
          :notice => l(:message_custom_reports_created)
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    @custom_report.is_public = false unless User.current.allowed_to?(:manage_public_custom_reports, @project) || User.current.admin?

    grab_filters_from_params(@custom_report)

    if @custom_report.update_attributes(params[:custom_report])
      redirect_to url_for(
          :controller => "custom_reports",
          :action => "show", :project_id => @project, :id => @custom_report.id),
          :notice => l(:message_custom_reports_updated)
    else
      render :action => "edit"
    end
  end

  def destroy
    if @custom_report.destroy
      flash[:notice] = l(:message_custom_reports_destroyed)
    else
      flash[:alert] = l(:message_custom_reports_not_destroyed)
    end
    redirect_to project_custom_reports_url(@project)
  end

  private

  def find_custom_reports
    @custom_reports = @project.custom_reports.visible
    grouped_reports = @custom_reports.group_by(&:is_public)
    @own_custom_reports = grouped_reports[false]
    @public_custom_reports = grouped_reports[true]
  end

  def find_custom_report
    @custom_report = @project.custom_reports.visible.find(params[:id])
  end

  def grab_filters_from_params(custom_report)
    @query = custom_report.query.clone
    build_query_from_params
    custom_report.filters = @query.filters
  end

  def authorize_to_manage
    @custom_report.allowed_to_manage? || deny_access
  end
end
