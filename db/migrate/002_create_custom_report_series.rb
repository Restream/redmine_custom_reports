class CreateCustomReportSeries < ActiveRecord::Migration
  def self.up
    create_table :custom_report_series do |t|
      t.column :custom_report_id, :integer
      t.column :name, :string
      t.column :filters, :text

      t.timestamps
    end
    add_index :custom_report_series, :custom_report_id
  end

  def self.down
    remove_index :custom_report_series, :custom_report_id
    drop_table :custom_report_series
  end
end
