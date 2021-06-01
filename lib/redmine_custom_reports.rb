ActiveSupport::Reloader.to_prepare do

  # Requiring plugin's controller and model
  require_dependency 'custom_report'
  require_dependency 'custom_report_series'
  require_dependency 'query_ext'
  require_dependency 'custom_reports_helper'
  require_dependency 'custom_reports_controller'

  # Check that patches applied on every request
  load 'redmine_custom_reports/project_patch.rb'
  load 'redmine_custom_reports/user_patch.rb'

end
