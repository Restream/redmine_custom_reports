jQuery(document).ready(function($) {

  function findSeriesId(el){
    var dataEl = $(el).closest('[data-series_id]');
    return dataEl.data().series_id;
  }

  function findFieldId(el){
    var dataEl = $(el).closest('[data-field_id]');
    return dataEl.data().field_id;
  }

  function toggleSeriesFilter(field_id) {
    var check_box = $('#cb_' + field_id);
    var operators = $('#operators_' + field_id);
    if (check_box.is(':checked')) {
      operators.show();
      operators.removeAttr('disabled');
      toggleSeriesFilterOperator(field_id);
    } else {
      operators.hide();
      operators.attr('disabled', 'disabled');
      enableSeriesFilterValues(field_id, []);
    }
    return 'todo';
  }

  function addSeriesFilter() {
    var selectEl = $(this);
    var field = selectEl.val();
    var series_id = findSeriesId(this);
    var field_id = series_id + '_' + field;
    var check_box = $('#cb_' + field_id);

    $('#tr_' + field_id).show();
    check_box.attr('checked', 'checked');
    toggleSeriesFilter(field_id);
    selectEl.val('');
    selectEl.children('option[value=' + field + ']').attr('disabled', 'disabled');
  }

  function toggleSeriesFilterOperator(field_id) {
    var operator = $('#operators_' + field_id);
    switch (operator.val()) {
      case '!*':
      case '*':
      case 't':
      case 'w':
      case 'o':
      case 'c':
        enableSeriesFilterValues(field_id, []);
        break;
      case '><':
        enableSeriesFilterValues(field_id, [0,1]);
        break;
      case '<t+':
      case '>t+':
      case 't+':
      case '>t-':
      case '<t-':
      case 't-':
        enableSeriesFilterValues(field_id, [2]);
        break;
      default:
        enableSeriesFilterValues(field_id, [0]);
        break;
    }
  }

  function enableSeriesFilterValues(field_id, indexes) {
    var values = $('.values_' + field_id);
    for(var i = 0; i < values.length; i++) {
      var value = values.eq(i);
      if (indexes.indexOf(i) >= 0) {
        value.removeAttr('disabled');
        value.closest('span').show();
      } else {
        value.attr('disabled', 'disabled');
        value.closest('span').hide();
      }
    }
    if (indexes.length > 0) {
      $('#div_values_' + field_id).show();
    } else {
      $('#div_values_' + field_id).hide();
    }
  }

  $('body').on('click', '.remove-custom-report-series', function(event){
    var series_count = fieldset = $('fieldset[data-series_id]').length;
    if (series_count > 1) {
      var series_id = findSeriesId(this);
      var fieldset = $('fieldset[data-series_id=' + series_id + ']');
      var destroy_field = fieldset.children('#' + series_id + '__destroy');
      destroy_field.val("true");
      fieldset.hide();
    } else {
      var cant_delete_message = $(this).data().cant_delete_message;
      alert(cant_delete_message);
    }
    event.preventDefault();
  });

  $('body').on('click', '.add-custom-report-series', function(event){
    var id = $(this).data().id;
    var fields = $(this).data().fields;
    var time = new Date().getTime();
    var regexp = new RegExp(id, 'g');
    $(this).before(fields.replace(regexp, time));
    event.preventDefault();
  });

  $('body').on('change', '.toggle_series_filter', function(){
    var field_id = findFieldId(this);
    toggleSeriesFilter(field_id);
  });

  $('body').on('change', '.toggle_series_filter_operator', function(){
    var field_id = findFieldId(this);
    toggleSeriesFilterOperator(field_id);
  });

  $('body').on('change', '.add_series_filter', addSeriesFilter);

  $('[data-field_id]').each(function(){
    var field_id = $(this).data().field_id;
    toggleSeriesFilterOperator(field_id);
  });

});

function toggle_multi_select(id) {
  var select = $('#'+id);
  if (select.attr('multiple')) {
    select.removeAttr('multiple');
  } else {
    select.attr('multiple', true);
  }
}
