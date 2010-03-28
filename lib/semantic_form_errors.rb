require 'hpricot'

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /<(input|label|textarea|select)/
    error_class = 'with_error'
    ermsg = instance.error_message
    title = ermsg.kind_of?(Array) ? '* ' + ermsg.join("\n* ") : ermsg

    nodes = Hpricot(html_tag)
    nodes.each_child do |node|
      unless !node.elem? || node[:type] == 'hidden'
        node[:class] = node.classes.push(error_class).join(' ') unless node.classes.include?(error_class)
        node[:title] = title
      end
    end
    nodes.to_html
  else
    html_tag
  end
end

module ActionView::Helpers::ActiveRecordHelper

  def error_message_on(object, method, *args)
    options = args.extract_options!
    unless args.empty?
      ActiveSupport::Deprecation.warn(
        'error_message_on takes an option hash instead of separate ' +
        'prepend_text, append_text, and css_class arguments', caller
      )

      options[:prepend_text] = args[0] || ''
      options[:append_text]  = args[1] || ''
      options[:css_class]    = args[2] || 'form_error'
    end
    options.reverse_merge!(:prepend_text => '', :append_text => '', :css_class => 'form_error')

    if (obj = (object.respond_to?(:errors) ? object : instance_variable_get("@#{object}"))) &&
      (errors = obj.errors.on(method))
      content_tag('span',
        "#{options[:prepend_text]}#{ERB::Util.html_escape(errors.is_a?(Array) ? errors.first : errors)}#{options[:append_text]}",
        :class => options[:css_class]
      )
    else
      ''
    end
  end
end
