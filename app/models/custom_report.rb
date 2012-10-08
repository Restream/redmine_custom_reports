class CustomReport < ActiveRecord::Base
  unloadable

  LINE_CHART = 'line'
  DONUT_CHART = 'donut'

  CHART_TYPES = [LINE_CHART, DONUT_CHART]

  belongs_to :project
  belongs_to :user

  serialize :filters

  validates_presence_of :project
  validates_presence_of :user
  validates_presence_of :is_public
  validates_presence_of :name
  validates_presence_of :group_by
  validates_presence_of :null_text
  validates_inclusion_of :chart_type, :in => CHART_TYPES

  named_scope :visible, lambda { |*args| 
      user = args.shift || User.current
      user_id = user.logged? ? user.id : 0
      {
        :conditions => ["(#{table_name}.is_public = ? OR #{table_name}.user_id = ?)", true, user_id]
      }
  }

  def data
    case chart_type

    when LINE_CHART
      line_data

    when DONUT_CHART
      donut_data

    else
      raise "unknown chart_type '#{chart_type}'"
    end
  end

  def query
    @query ||= build_query
  end

  def xkey
    :label
  end

  def ykeys
    [:value]
  end

  def labels
    [query.group_by_column.caption]
  end

  private

  def donut_data
    query.issue_count_by_group.map do |k,v| 
      { :label => (k || null_text).to_s, :value => v }
    end
  end

  def line_data
    query.issue_count_by_group.map do |k,v| 
      { :label => (k || null_text).to_s, :value => v }
    end
  end

  def build_query
    Query.new(
      :name => name, 
      :filters => filters, 
      :group_by => group_by, 
      :is_public => true, 
      :project => project)
  end
end
