module DeviseHelper
  def devise_error_messages!    
    html = '<div class="tip tip-error">' 
    html += resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join 
    html += '</div>'
    return html.html_safe if resource.errors.any? 
  end
end 
