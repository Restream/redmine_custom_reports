class CustomReport < ActiveRecord::Base
  unloadable

  CHART_TYPES = %w(pie donut bar horizontal_bar)

  belongs_to :project
  belongs_to :user

  serialize :filters

  validates_presence_of :project
  validates_presence_of :user
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

  def query
    @query ||= build_query
  end

  def data
    @data ||= query.issue_count_by_group.map do |k, v|
      { :label => (k || custom_report.null_text).to_s, :value => v }
    end
  end

  def allowed_to_manage?(user = User.current)
    user.allowed_to?(
        is_public? ? :manage_public_custom_reports : :manage_custom_reports,
        project
    )
  end

  private

  def build_query
    Query.new(
      :name => name,
      :filters => filters,
      :group_by => group_by,
      :is_public => true,
      :project => project)
  end
end
