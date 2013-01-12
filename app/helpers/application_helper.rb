require "builder"
require 'open-uri'
require 'net/http'

module ApplicationHelper

  def active?(url)
	current_page?(url) ? 'class=active' : ''
  end

  def error_messages(object)     
    html = '<div class="tip tip-error">' 
    html += object.errors.full_messages.map { |msg| content_tag(:li, msg) }.join 
    html += '</div>'
    return html.html_safe if object.errors.any? 
  end

  def markdown(text)
    markdown = Redcarpet::Markdown.new(HTMLCustomRenderer,
        :autolink => true, :space_after_headers => true, :tables => true)
    markdown.render(text).html_safe
  end 

  def textilize(text)
    CodeFormatter.new(text).to_html.html_safe unless text.blank?
  end

  def tab_link(name, url)
    selected = url.all? { |key, value| params[key] == value }
    link_to(name, url, :class => (selected ? "selected tab" : "tab"))
  end

  def avatar_url(comment_or_user, size = 64)
    default_url = "guest.png"
    token = gravatar_token(comment_or_user)
    if token.present?
      token = gravatar_token(comment_or_user)
      "http://gravatar.com/avatar/#{token}.png?s=#{size}"
    else
      token = gravatar_token(comment_or_user)
      #&d=#{CGI.escape(default_url)}
      url = URI.parse("http://gravatar.com/avatar/#{token}.png?s=#{size}&d=http://toymetric.com/assets/head_watermark.png")
      return url 
      
      #Net::HTTP.start(url.host, url.port) do |http|
      #  if http.head(url.request_uri).code == "200"
      #      if comment_or_user.class == User
      #          # The token is good and a gravatar was found, save the token for next time 
      #          comment_or_user.update_attribute(:gravatar_token, token)
      #      end            
      #      return url
      #  else 
      #      return default_url 
      #  end
      #end
    end
  end

  # TODO refactor me into comment/user class
  def gravatar_token(comment_or_user)
    case comment_or_user
    when Comment
      token = gravatar_token(comment_or_user.user)
      if token.present?
        token
      elsif comment_or_user.email.present?
        Digest::MD5.hexdigest(comment_or_user.email.downcase)        
      end
    when User
      if comment_or_user.gravatar_token.present?
        comment_or_user.gravatar_token
      elsif comment_or_user.email.present?
        Digest::MD5.hexdigest(comment_or_user.email.downcase)
      end
    else nil
    end
  end

  def video_tag(path, options = {})
    xml = Builder::XmlMarkup.new
    xml.video :width => options[:width], :height => options[:height], :poster => options[:poster], :controls => "controls", :preload => "none" do
      xml.source :src => "#{path}.mp4", :type => "video/mp4"
      xml.source :src => "#{path}.m4v", :type => "video/mp4"
      xml.source :src => "#{path}.webm", :type => "video/webm"
      xml.source :src => "#{path}.ogv", :type => "video/ogg"
    end.html_safe
  end

  def field(f, attribute, options = {})
    return if f.object.new_record? && cannot?(:create, f.object, attribute)
    return if !f.object.new_record? && cannot?(:update, f.object, attribute)
    label_name = options.delete(:label)
    type = options.delete(:type) || :text_field
    content_tag(:div, (f.label(attribute, label_name) + f.send(type, attribute, options)), :class => "field")
  end
end

# create a custom renderer
class HTMLCustomRenderer < Redcarpet::Render::HTML
  include Sprockets::Helpers::RailsHelper
  include ActionView::Helpers
  
  def link(link, title, content)
    begin            
        if ["User", "user"].include?(content)
            user = eval(content.capitalize).find_by_name(link)
            link_to("#{user.display_name}", "/users/#{user.id}")         
        elsif ["Episode", "episode"].include?(content)
            ep = eval(content.capitalize).find(link) 
            link_to("EP ##{ep.position} - #{ep.name}", "/episodes/#{ep.id}")
        else 
            link_to(content, link, :title => title)
        end 
    rescue 
        "#{content} ##{link} NOT FOUND"    
    end   
  end
  
  def image(link, title, alt_text)      
    if (position_match = alt_text.match(/(center|left|right)-(\d+)/))
        if (match = link.match(/photo-(\d+)-(\d+)/))            
            if asset = Asset.where(:assetable_id => match[1], :id => match[2]).first             
                link = asset.attachment.url(:normal)               
            else 
                "<div class='thumb #{alt_text}'>{Photo Not Found!}</div>".html_safe
            end
        end 
        link_to(image_tag(link, :class => "thumb #{position_match[1]}", :style => "max-width: #{position_match[2]}px"), link, :class => "gallery", :rel => "gallery photo")
    else 
        image_tag(link, :title => title, :alt => alt_text)
    end
  end
end
