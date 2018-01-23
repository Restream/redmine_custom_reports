require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

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
    @user        = User.find(1)
    User.current = @user

    @request                   = ActionController::TestRequest.new
    @request.session[:user_id] = @user.id

    @custom_report = @project.custom_reports.create!(
      name:              'name',
      description:       'description',
      group_by:          'status',
      user_id:           @user.id,
      is_public:         true,
      chart_type:        'pie',
      series_attributes: [{
        name:    'series1',
        filters: {}
      }]
    )
  end

  def test_show_all_custom_reports
    get :index, project_id: @project.identifier
    assert_response :success
  end

  def test_show_custom_report
    get :new, project_id: @project.identifier, id: @custom_report.id
    assert_response :success
  end

  def test_show_new_custom_report
    get :new, project_id: @project.identifier
    assert_response :success
  end

  def test_create_custom_report
    series_name    = 'series2-1'
    series_filters = { 'status_id' => { operator: '=', values: ['1'] } }
    attrs          = {
      name:              'name2',
      description:       'description2',
      group_by:          'status',
      user_id:           @user.id,
      is_public:         true,
      chart_type:        'donut',
      series_attributes: {
        0 => {
          name: series_name,
          flt:  {
            f:  ['status_id'],
            op: { status_id: '=' },
            v:  { status_id: ['1'] }
          }
        }
      }
    }
    post :create, project_id: @project.identifier, custom_report: attrs
    assert_response :redirect
    custom_report = @project.custom_reports.find_by_name(attrs[:name])
    assert custom_report
    assert_equal attrs[:description], custom_report.description
    assert_equal attrs[:group_by], custom_report.group_by
    assert_equal attrs[:user_id], custom_report.user_id
    assert_equal attrs[:is_public], custom_report.is_public
    assert_equal attrs[:chart_type], custom_report.chart_type

    assert_equal 1, custom_report.series.count
    series = custom_report.series.first
    assert_equal series_name, series.name
    assert_equal series_filters, series.filters
  end

  def test_show_edit_custom_report
    get :edit, project_id: @project.identifier, id: @custom_report.id
    assert_response :success
  end

  def test_update_custom_report
    old_series     = @custom_report.series.first
    series_name    = 'series2-1'
    series_filters = { 'status_id' => { operator: '=', values: ['1'] } }
    attrs          = {
      name:              'name2',
      description:       'description2',
      group_by:          'status',
      user_id:           @user.id,
      is_public:         true,
      chart_type:        'donut',
      series_attributes: {
        0 => {
          id:       old_series.id,
          _destroy: true
        },
        1 => {
          name: series_name,
          flt:  {
            f:  ['status_id'],
            op: { status_id: '=' },
            v:  { status_id: ['1'] }
          }
        }
      }
    }
    put :update, project_id: @project.identifier, id: @custom_report.id, custom_report: attrs
    assert_response :redirect
    @custom_report.reload
    assert_equal attrs[:description], @custom_report.description
    assert_equal attrs[:group_by], @custom_report.group_by
    assert_equal attrs[:user_id], @custom_report.user_id
    assert_equal attrs[:is_public], @custom_report.is_public
    assert_equal attrs[:chart_type], @custom_report.chart_type

    assert_equal 1, @custom_report.series.count
    series = @custom_report.series.first
    assert_equal series_name, series.name
    assert_equal series_filters, series.filters
  end

  def test_destroy_custom_report
    delete :destroy, project_id: @project.identifier, id: @custom_report.id
    assert_response :redirect
    custom_report = CustomReport.find_by_id @custom_report.id
    assert_nil custom_report
  end
end
