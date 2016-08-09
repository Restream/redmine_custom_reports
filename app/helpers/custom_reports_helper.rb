module CustomReportsHelper
  def sanitized_object_name(object_name)
    object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, '_').sub(/_$/, '')
  end

  def operators_for_select(filter_type)
    Query.operators_by_filter_type[filter_type].collect { |o| [l(Query.operators[o]), o] }
  end

  def query_options_for_select(query)
    options = query.available_filters.collect do |field, options|
      unless query.has_filter?(field)
        [options[:name] || l(('field_' + field.to_s.gsub(/_id$/, '')).to_sym), field]
      end
    end
    options = [['', '']] + options.compact
    options_for_select(options)
  end

  def link_to_add_custom_report_series(name, f)
    new_object = f.object.series.build
    id         = new_object.object_id
    fields     = f.fields_for(:series, new_object, child_index: id) do |builder|
      render('series', f: builder)
    end
    link_to(name, '#',
      class:        'add-custom-report-series',
      'data-id'     => id,
      'data-fields' => fields.gsub("\n", '')
    )
  end

  def width_style_for_series(custom_report)
    'width:100%;'
  end
end
