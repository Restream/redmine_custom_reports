require_dependency 'user'

module RedmineCustomReports
  module UserPatch
    def self.included(base)
      base.send :has_many, :custom_reports, dependent: :destroy
    end
  end
end

unless User.included_modules.include? RedmineCustomReports::UserPatch
  User.send :include, RedmineCustomReports::UserPatch
end