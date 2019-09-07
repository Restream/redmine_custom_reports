class CreateCustomReports < ActiveRecord::Migration[4.2]
  def self.up
    unless table_exists? :custom_reports
      create_table :custom_reports do |t|
        t.column :project_id, :integer
        t.column :user_id, :integer, default: 0, null: false
        t.column :is_public, :boolean, default: false, null: false
        t.column :name, :string, default: '', null: false
        t.column :description, :text
        t.column :filters, :text
        t.column :group_by, :string, default: '', null: false
        t.column :chart_type, :string
        t.column :null_text, :string, default: 'Null', null: false

        t.timestamps
      end
      add_index :custom_reports, :project_id
      add_index :custom_reports, :user_id
    end
  end

  def self.down
    if table_exists? :custom_reports
      remove_index :custom_reports, :project_id
      remove_index :custom_reports, :user_id
      drop_table :custom_reports
    end
  end
end
