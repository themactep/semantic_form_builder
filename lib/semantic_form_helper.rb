module SemanticFormHelper
  include ActionView::Helpers::FormTagHelper

  def wrapping(type, field_name, label_text, field, error_message, options = {})
    label = label_tag(field_name, label_text)

    to_return = []
    to_return << label unless %w(radio check).include?(type)
    to_return << field
    to_return << label if %w(radio check).include?(type)
    to_return << error_message

    content_tag 'p', to_return, :class => %Q{#{type}-field #{options[:class]}}.strip
  end

  def semantic_group(type, field_name, label_text, fields, options = {})
    to_return = []
    to_return << label_tag(field_name, label_text)
    to_return << content_tag(:div, fields.join, :class => 'input')

    content_tag 'p', to_return, :class => %Q{#{type}-fields #{options[:class]}}.strip
  end

  def boolean_field_wrapper(input, name, value, label_text, help = nil)
    field = []
    field << label_tag(input, label_text)
    field << content_tag('div', help, :class => 'help') if help
    field
  end

  def check_box_tag_group(name, values, options = {})
    selections = []
    values.each do |item|
      if item.is_a?(Hash)
        value = item[:value]
        text = item[:label]
        help = item.delete(:help)
      else
        value = item
        text = item
      end
      box = check_box_tag(name, value)
      selections << boolean_field_wrapper(box, name, value, text)
    end
    label = options[:label]
    semantic_group('check-box', name, label, selections, options)
  end

  def spinner
    content = image_tag('16x16_spinner.gif', :alt => "")
    content << I18n.t('form.processing')
    content_tag 'span', content, :style => 'display: none;', :class => 'spinner'
  end

end
