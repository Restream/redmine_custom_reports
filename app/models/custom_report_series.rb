class CustomReportSeries < ActiveRecord::Base
  unloadable

  serialize :filters

  belongs_to :custom_report, inverse_of: :series

  validates :name, presence: true

  def query
    @query ||= build_query
  end

  def data(data_keys = [])
    _keys = data_keys.dup
    _data = {
      key:    name,
      values: data_hash.map do |k, v|
        _keys.delete(k)
        { label: data_label_text(k), value: v }
      end
    }
    _keys.each do |key|
      _data[:values] << { label: data_label_text(key), value: 0 }
    end
    _data
  end

  def data_hash
    true
    @data_hash ||= (query.result_count_by_group || {})
  end

  def flt=(*args)
    filters_hash  = args.extract_options!
    query.filters = {}
    query.add_filters(filters_hash[:f], filters_hash[:op], filters_hash[:v])
    self.filters = query.filters
  end

  private

  def build_query
    QueryExt.new(
      name:     name,
      filters:  filters,
      group_by: custom_report.try(:group_by),
      project:  custom_report.try(:project))
  end

  def data_label_text(label)
    (label.present? ? label : custom_report.null_text).to_s
  end
end
