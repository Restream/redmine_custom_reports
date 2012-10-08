module RedmineCustomReports
  module ProjectPatch
    def self.included(base)
      base.send :has_many, :custom_reports, :dependent => :destroy
    end
  end
end
