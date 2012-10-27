require File.dirname(__FILE__) + '/../test_helper'

class CustomReportsControllerTest < ActionController::TestCase
  fixtures :projects, :trackers, :issue_statuses, :issues,
           :enumerations, :users, :issue_categories,
           :projects_trackers,
           :roles,
           :member_roles,
           :members

  def setup
    @project = Project.find(1)
    @project.enable_module! :custom_reports

    # admin
    @user = User.find(2)
    User.current = @user

    @request = ActionController::TestRequest.new
    @request.session[:user_id] = @user.id
  end

  def test_show_custom_reports_for_user
    @user = User.find(2)
    User.current = @user
    @request.session[:user_id] = @user.id
    user_role = Role.find(1)
    user_role.add_permission! :manage_custom_reports

    get :index, :project_id => @project.name
    assert_response :success
  end

  def test_show_custom_reports
    get :index, :project_id => @project.name
    assert_response :success
  end

  def test_show_new_custom_report
    get :new, :project_id => @project.name
    assert_response :success
  end

  def test_create_custom_report
    attrs = {
        :role_before_id => @role_before.id,
        :role_after_id => @role_after.id
    }
    post :create, :project_id => @project.name, :custom_report => attrs
    assert_response :redirect
    custom_report = @project.custom_reports.find(:first, :conditions => {
        :role_before_id => attrs[:role_before_id]
    })
    assert custom_report
    assert_equal attrs[:role_after_id], custom_report.role_after_id
  end

  def test_show_edit_custom_report
    custom_report = CustomReport.create!({
        :project_id => @project.id,
        :role_before_id => @role_before.id,
        :role_after_id => @role_after.id
    })
    get :edit, :project_id => @project.name, :id => custom_report.id
    assert_response :success
  end

  def test_update_custom_report
    custom_report = @project.custom_reports.create!({
        :project_id => @project.id,
        :role_before_id => @role_before.id,
        :role_after_id => 5
    })
    attrs = {
        :role_before_id => @role_before.id,
        :role_after_id => @role_after.id
    }
    put :update, :project_id => @project.name, :id => custom_report.id,
        :custom_report => attrs
    assert_response :redirect
    custom_report.reload
    assert_equal attrs[:role_after_id], custom_report.role_after_id
  end

  def test_destroy_custom_report
    custom_report = CustomReport.create!({
        :project_id => @project.id,
        :role_before_id => @role_before.id,
        :role_after_id => @role_after.id
    })
    delete :destroy, :project_id => @project.name, :id => custom_report.id
    assert_response :redirect
    custom_report =  CustomReport.find_by_id custom_report.id
    assert_nil custom_report
  end
end
