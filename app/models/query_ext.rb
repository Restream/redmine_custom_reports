class QueryExt < defined?(IssueQuery) ? IssueQuery : Query
  unloadable

  def initialize(*args)
    super
    available_columns.each do |col|
      make_groupable!(col) if groupable_ext?(col)
    end
  end

  def model_name
    superclass.model_name
  end

  def sorted_available_filters
    available_filters.sort { |a, b| a[1][:order] <=> b[1][:order] }
  end

  private

  def groupable_ext?(col)
    col.respond_to?(:custom_field) && !col.custom_field.multiple? &&
        %w(string).include?(col.custom_field.field_format)
  end

  def make_groupable!(col)
    col.groupable = col.custom_field.order_statement
  end
end
