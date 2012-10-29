class RemoveFiltersFromCustomReports < ActiveRecord::Migration
  def self.up
    remove_column :custom_reports, :filters
  end

  def self.down
    add_column :custom_reports, :filters, :string
  end
end
