Redmine::Plugin.register :redmine_custom_reports do
  name 'Redmine Custom Reports (with charts) plugin'
  author 'Restream'
  description 'Redmine plugin for custom reports with charts'
  version '0.1.5'
  url 'https://github.com/Restream/redmine_custom_reports'
  author_url 'https://github.com/Restream'

  project_module :custom_reports do
    permission :manage_custom_reports,
                { custom_reports: [:new, :create, :edit, :update, :destroy] }
    permission :view_custom_reports, { custom_reports: [:index, :show] }
    permission :manage_public_custom_reports, {}
  end

  menu :project_menu,
       :custom_reports,
       { controller: 'custom_reports', action: 'index' },
       param:  :project_id,
       before: :settings
end

# Require plugin after register
require 'redmine_custom_reports'
