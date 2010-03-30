module SemanticFormHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::TranslationHelper

  #FIXME add rails attributes
  ATTRIBUTES_INPUT = %w(
    accept align alt checked disabled maxlength name readonly size src type value
    accesskey class dir id lang style tabindex title xml:lang
    onblur onchange onclick ondblclick onfocus onmousedown onmousemove
    onmouseout onmouseover onmouseup onkeydown onkeypress onkeyup onselect
  )

  #FIXME add rails attributes
  ATTRIBUTES_TEXTAREA = %w(
    cols rows
    disabled name readonly
    accesskey class dir id lang style tabindex title xml:lang
    onblur onchange onclick ondblclick onfocus onmousedown onmousemove
    onmouseout onmouseover onmouseup onkeydown onkeypress onkeyup onselect
  )

  #FIXME add rails attributes
  ATTRIBUTES_SELECT = %w(
    disabled multiple name size
    class dir id lang style tabindex title xml:lang
    onblur onchange onclick ondblclick onfocus onmousedown onmousemove
    onmouseout onmouseover onmouseup onkeydown onkeypress onkeyup onselect
    include_blank
  )

  #FIXME add rails attributes
  ATTRIBUTES_LABEL = %w(
    for
    accesskey class dir id lang style title xml:lang
    onblur onclick ondblclick onfocus onmousedown onmousemove
    onmouseout onmouseover onmouseup onkeydown onkeypress onkeyup
    label help required
  )

  # logger shorthand, for debugging purposes
  def log(text)
    Rails.logger.info text
  end

  # shorthand to wrap content in a paragraph
  def wrap(content, options = {})
    content_tag 'p', content, options
  end

  # complete field with lable and error message, and wrap whole bundle
  # in a paragraph unless asked not to do so
  def bundleize(field, method, options = {})
    bundle = [ build_label(method, options), field, build_error_message(method) ].join
    wrap(bundle) unless options[:dont_wrap]
  end

  # return localization domain, build one if required
  def localization_domain
    @localization_domain ||= build_localization_domain
  end

  # build localization domain
  # sanitize object name for nested attributes
  # TODO: re-use InstanceTag.sanitized_object_name instead?
  def build_localization_domain
    domain = 'activerecord.attributes.'
    domain << @object_name.to_s.gsub(/\[[0-9]\]/,'').gsub('[','.').to_s.gsub(']','')
  end

  # construct label
  def build_label(method, options={})
    return nil if options[:dont_label]
    options = options.find_by_keys(ATTRIBUTES_LABEL)

    label_parts = []
    label_text = options.delete(:label)
    label_text ||= t("#{localization_domain}.#{method}")
    label_parts << label_text

    if options.delete(:required)
      # add 'required' class
      options[:class] = [options[:class], 'required'].compact.join(' ')

      # add visual mark to the label, for sake of usability
      # TODO: or leave it to css/javascript?
      label_parts << content_tag('span', t('form.required_mark'), :class => 'mark')
    end

    # add help
    help = options.delete(:help)
    label_parts << content_tag('span', help, :class => 'help') if help

    # build the label
    label_tag "#{@object_name}_#{method}", label_parts.join(" ")
  end

  # construct error message
  def build_error_message(method)
    error_message_on method,
      :prepend_text => t("#{localization_domain}.#{method}") << " ",
      :append_text  => '.'
  end

  # busy indicator image
  def spinner
    content = image_tag('16x16_spinner.gif', :alt => "")
    content << t('form.processing')
    content_tag 'span', content, :style => 'display: none;', :class => 'spinner'
  end

  # TODO change values handling similar to select and collection_select
  def check_box_tag_group(name, values, options = {})
    selections = values.map do |item|
      cnt += 1 rescue cnt = 0
      if item.is_a?(Hash)
        value = item[:value]
        text  = item[:label]
        help  = item.delete(:help)
      else
        value = item
        text  = item
      end
      box = check_box_tag("#{name}[#{cnt}]", value)
      boolean_field_wrapper(box, "#{name}[#{cnt}]", value, text, help)
    end
    wrap [ build_label(name, options),
           content_tag('span', selections.join, :class => 'checkboxes', :id => name)
    ].join
  end

  def boolean_field_wrapper(input, name, value, text, help = nil)
    field = []
    field << label_tag(name, "#{input} #{text}")
    field << content_tag('div', help, :class => 'help') if help
    field << tag('br')
  end

  # a group of radio buttons
  # TODO rewrite!
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
      selections << boolean_field_wrapper(radio_button, "#{@object_name}_#{method.to_s}", tag_value, value_text)
    end
    selections
    field_name, label_text, error_text, options = field_settings(method, options)
    semantic_group('radio', field_name, label_text, selections, options)
  end

  # a group of check boxes
  # TODO rewrite!
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
      selections << boolean_field_wrapper(check_box, "#{@object_name}_#{method.to_s}", checked_value, value_text)
    end
    field_name, label_text, error_text, options = field_settings(method, options)
    semantic_group('check-box', field_name, label_text, selections, options)
  end
end
