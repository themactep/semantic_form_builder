class SemanticFormBuilder < ActionView::Helpers::FormBuilder
  include SemanticFormHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper

  def field_settings(method, options = {}, tag_value = nil)
    field_name = "#{@object_name}_#{method.to_s}"

    options[:class] ||= ""
    options[:class] += options[:required] ? " required" : ""

    default_label = tag_value.nil? ? method.to_s : "#{tag_value.to_s.gsub(/\_/, " ")}"
    label = options[:label] ? options.delete(:label) : I18n.t("activerecord.attributes.#{@object_name}.#{default_label}")
    label += "<sup>*</sup>" if options[:required]

    [field_name, label, error_message_on(method), options]
  end

  def text_field(method, options = {})
    field_name, label,error_message, options = field_settings(method, options)
    wrapping("text", field_name, label, super, error_message, options)
  end

  def file_field(method, options = {})
    field_name, label,error_message, options = field_settings(method, options)
    wrapping("file", field_name, label, super, error_message, options)
  end

  def datetime_select(method, options = {})
    field_name, label,error_message, options = field_settings(method, options)
    wrapping("datetime", field_name, label, super, error_message, options)
  end

  def date_select(method, options = {})
    field_name, label,error_message, options = field_settings(method, options)
    wrapping("date", field_name, label, super, error_message, options)
  end

  def radio_button(method, tag_value, options = {})
    field_name, label,error_message, options = field_settings(method, options)
    wrapping("radio", field_name, label, super, error_message, options)
  end

  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
    field_name, label,error_message, options = field_settings(method, options)
    wrapping("check-box", field_name, label, super, error_message, options)
  end

  def select(method, choices, options = {}, html_options = {})
    field_name, label,error_message, options = field_settings(method, options)
    wrapping("select", field_name, label, super, error_message, options)
  end

  def time_zone_select(method, choices, options = {}, html_options = {})
    field_name, label,error_message, options = field_settings(method, options)
    # wrapping("time-zone-select", field_name, label, super, options)
    select_box = this_check_box = @template.select(@object_name, method, choices, options.merge(:object => @object), html_options)
    wrapping("time-zone-select", field_name, label, select_box, error_message, options)
  end

  def password_field(method, options = {})
    field_name, label,error_message, options = field_settings(method, options)
    wrapping("password", field_name, label, super, error_message, options)
  end

  def text_area(method, options = {})
    field_name, label,error_message, options = field_settings(method, options)
    wrapping("textarea", field_name, label, super, error_message, options)
  end

  def submit(method, options = {})
    field_name, label,error_message, options = field_settings(method, options.merge( :label => "&nbsp;"))
    wrapping("submit", field_name, label, super, error_message, options)
  end

  def submit_or_cancel(submit_name = I18n.t('form.submit'), cancel_name = I18n.t('form.cancel'), options = {})
    options.merge!(:onclick => "$(this).parent().children('input').hide();$(this).siblings('.spinner').show();")
    submit_button = @template.submit_tag(submit_name, options)
    cancel_button = tag(:input, { :type => 'reset',
                                  :value => cancel_name,
                                  :onclick => "if (confirm('#{I18n.t('form.confirm_cancelation')}')) history.back();"
                                }.update(options.stringify_keys))
    content_tag :p, submit_button + cancel_button + spinner, options.merge(:class => 'form-buttons')
  end

  def radio_button_group(method, values, options = {})
    selections = []
    values.each do |value|
      if value.is_a?(Hash)
        tag_value = value[:value]
        label = value[:label]
        help = value.delete(:help)
      else
        tag_value = value
        value_text = value
      end
      radio_button = @template.radio_button(@object_name, method, tag_value, options.merge(:object => @object, :help => help))
      selections << boolean_field_wrapper(
                        radio_button, "#{@object_name}_#{method.to_s}",
                        tag_value, value_text)
    end
    selections    
    field_name, label, options = field_settings(method, options)
    semantic_group("radio", field_name, label, selections, options)    
  end
  
  def check_box_group(method, values, options = {})
    selections = []
    values.each do |value|
      if value.is_a?(Hash)
        checked_value = value[:checked_value]
        unchecked_value = value[:unchecked_value]
        value_text = value[:label]
        help = value.delete(:help)
      else
        checked_value = 1
        unchecked_value = 0
        value_text = value
      end
      check_box = @template.check_box(@object_name, method, options.merge(:object => @object), checked_value, unchecked_value)
      selections << boolean_field_wrapper(
                        check_box, "#{@object_name}_#{method.to_s}",
                        checked_value, value_text)
    end
    field_name, label, options = field_settings(method, options)
    semantic_group("check-box", field_name, label, selections, options)    
  end
end
