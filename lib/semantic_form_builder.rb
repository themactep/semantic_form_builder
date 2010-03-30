class SemanticFormBuilder < ActionView::Helpers::FormBuilder
  include SemanticFormHelper

  # regular text field
  def text_field(method, options = {})
    field = super(method, options.find_by_keys(ATTRIBUTES_INPUT))
    bundleize(field, method, options)
  end

  # regular password field
  def password_field(method, options = {})
    field = super(method, options.find_by_keys(ATTRIBUTES_INPUT))
    bundleize(field, method, options)
  end

  # regular file field
  def file_field(method, options = {})
    field = super(method, options.find_by_keys(ATTRIBUTES_INPUT))
    bundleize(field, method, options)
  end

  # regular text area
  def text_area(method, options = {})
    field = super(method, options.find_by_keys(ATTRIBUTES_TEXTAREA))
    bundleize(field, method, options)
  end

  # regular select
  def select(method, choices, options = {}, html_options = {})
    options[:include_blank] = t('form.select.prompt') if options[:include_blank] == true
    field = super(method, choices, options.find_by_keys(ATTRIBUTES_SELECT), html_options)
    bundleize(field, method, options)
  end

  # regular collection_select
  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    field = super(method, collection, value_method, text_method, options.find_by_keys(ATTRIBUTES_SELECT), html_options)
    bundleize(field, method, options)
  end

  # date selector as a text field with jQuery datepicker
  def date_select(method, options = {})
    options.merge!({ :size => 10, :class => 'datepicker' })
    text_field(method, options)
  end

  # date and time selector as a text field with jQuery datepicker
  def datetime_select(method, options = {})
    options.merge!({ :size => 10, :class => 'datepicker' })
    text_field(method, options)
  end

  # time zone selector
  def time_zone_select(method, choices, options = {}, html_options = {})
    field = select(method, choices, options.merge(:object => @object), html_options)
    bundleize(field, method, options)
  end

  # regular radio button
  def radio_button(method, tag_value, options = {})
    field = super(method, tag_value, options.find_by_keys(ATTRIBUTES_INPUT))
    bundleize(field, method, options)
  end

  # regular check box
  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
    field = super(method, options.find_by_keys(ATTRIBUTES_INPUT), checked_value, unchecked_value)
    bundleize(field, method, options)
  end

  # submit button with spinner
  def submit(submit_name = t('form.submit'), options = {})
    submit_button = @template.submit_tag(submit_name,
      options.dup.merge!(:onclick => "$(this).parent().children('input').hide();$(this).siblings('.spinner').show();"))

    wrap [ submit_button, spinner ], options.merge(:class => 'form-buttons')
  end

  # set of submit and reset buttons
  def submit_or_cancel(submit_name = t('form.submit'), cancel_name = t('form.cancel'), options = {})
    submit_button = @template.submit_tag(submit_name, options.dup)
    cancel_button = @template.cancel_tag(cancel_name, options.dup)

    wrap [ submit_button, cancel_button, spinner ], options.merge(:class => 'form-buttons')
  end

end
