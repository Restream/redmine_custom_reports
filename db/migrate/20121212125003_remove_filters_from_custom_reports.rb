class RemoveFiltersFromCustomReports < ActiveRecord::Migration[4.2]
  def self.up
    if column_exists? :custom_reports, :filters
      remove_column :custom_reports, :filters
    end
  end

  def self.down
    unless column_exists? :custom_reports, :filters
      add_column :custom_reports, :filters, :string
    end
  end
end
