require 'redmine'

Rails.configuration.to_prepare do
  require_dependency 'project'
  unless Project.included_modules.include? RedmineCustomReports::ProjectPatch
    Project.send :include, RedmineCustomReports::ProjectPatch
  end
  require_dependency 'user'
  unless User.included_modules.include? RedmineCustomReports::UserPatch
    User.send :include, RedmineCustomReports::UserPatch
  end
end

Redmine::Plugin.register :redmine_custom_reports do
  name 'Redmine Custom Reports (with charts) plugin'
  author 'Danil Tashkinov'
  description 'Redmine plugin for custom reports with charts'
  version '0.1.5'
  url 'https://github.com/nodecarter/redmine_custom_reports'
  author_url 'https://github.com/Undev'

  project_module :custom_reports do
    permission :manage_custom_reports,
                { :custom_reports => [:new, :create, :edit, :update, :destroy] }
    permission :view_custom_reports, { :custom_reports => [:index, :show] }
    permission :manage_public_custom_reports, {}
  end

  menu :project_menu,
       :custom_reports,
       { :controller => 'custom_reports', :action => 'index' },
       :param => :project_id,
       :before => :settings
end
