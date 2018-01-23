require_dependency 'project'

module RedmineCustomReports
  module ProjectPatch
    def self.included(base)
      base.send :has_many, :custom_reports, dependent: :destroy
    end
  end
end

unless Project.included_modules.include? RedmineCustomReports::ProjectPatch
  Project.send :include, RedmineCustomReports::ProjectPatch
end