module RedmineCustomReports
  module UserPatch
    def self.included(base)
      base.send :has_many, :custom_reports, :dependent => :destroy
      base.send :unloadable
    end
  end
end
