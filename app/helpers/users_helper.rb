module UsersHelper

    def display_link(user, icon = true) 
        icon ? icon = '<div class="icon-user inline"></div>' : icon = '' 
        link_to ( icon + user.display_name).html_safe, user, :style => "color:#1B97F2;"
    end 
end
