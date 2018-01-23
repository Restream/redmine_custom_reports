class CustomReport < ActiveRecord::Base
  unloadable

  CHART_TYPES  = %w(undev_pie pie donut bar horizontal_bar stacked_bar)
  MULTI_SERIES = %w(horizontal_bar stacked_bar)

  belongs_to :project
  belongs_to :user
  has_many :series, class_name: 'CustomReportSeries'

  validates_presence_of :project
  validates_presence_of :user
  validates_presence_of :name
  validates_presence_of :group_by
  validates_presence_of :null_text
  validates_inclusion_of :chart_type, in: CHART_TYPES

  accepts_nested_attributes_for :series, allow_destroy: true

  scope :visible, lambda { |*args|
    user    = args.shift || User.current
    user_id = user.logged? ? user.id : 0
    where "(#{table_name}.is_public = ? OR #{table_name}.user_id = ?)", true, user_id
  }

  scope :by_name, -> { order('name') }

  def groupable_columns
    QueryExt.new().groupable_columns.select do |col|
      if col.respond_to? :custom_field
        col.custom_field.is_for_all ||
          project.all_issue_custom_fields.include?(col.custom_field)
      else
        true
      end
    end
  end

  def info
    {
      chart_type:       chart_type,
      group_by_caption: group_by_column.try(:caption),
      series_count:     series.count,
      multi_series:     multi_series?
    }
  end

  def multi_series?
    MULTI_SERIES.include?(chart_type)
  end

  def data
    if multi_series?
      # all series must have the same keys
      keys = series.map { |s| s.data_hash.keys }.flatten.uniq
      series.map { |s| s.data(keys) }
    else
      series.map { |s| s.data }
    end
  end

  def allowed_to_manage?(user = User.current)
    user.allowed_to?(
      is_public? ? :manage_public_custom_reports : :manage_custom_reports,
      project
    )
  end

  def group_by_column
    groupable_columns.detect { |col| col.name.to_s == group_by }
  end
end
