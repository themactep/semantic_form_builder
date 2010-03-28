module SemanticFormHelper

  def wrapping(type, field_name, label, field, error_message, options = {})
    help = %Q{<span class="help">#{options[:help]}</span>} if options[:help]
    to_return = []
    css = %Q{#{type}-field #{options[:class]}}.strip
    to_return << %Q{<p class="#{css}">}
    to_return << %Q{<label for="#{field_name}">#{label}#{help}</label>} unless %w(radio check submit).include?(type)
    to_return << %Q{<span class="input">}
    to_return << field
    to_return << %Q{<label for="#{field_name}">#{label}</label>} if %w(radio check).include?(type)
    to_return << %Q{</span>}
    to_return << error_message
    to_return << %Q{</p>}
  end

  def semantic_group(type, field_name, label, fields, options = {})
    help = %Q{<span class="help">#{options[:help]}</span>} if options[:help]
    to_return = []
    to_return << %Q{<div class="#{type}-fields #{options[:class]}">}
    to_return << %Q{<label for="#{field_name}">#{label}#{help}</label>}
    to_return << %Q{<div class="input">}    
    to_return << fields.join
    to_return << %Q{</div></div>}
  end

  def boolean_field_wrapper(input, name, value, text, help = nil)
    field = []
    field << %Q{<label>#{input} #{text}</label>}
    field << %Q{<div class="help">#{help}</div>} if help
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
    semantic_group("check-box", name, label, selections, options)    
  end      

end
