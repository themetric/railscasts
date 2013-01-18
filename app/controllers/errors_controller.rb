class ErrorsController < ApplicationController
    
    def routing            
        ep = Episode.find_by_alternate_url(params[:a])           
        # Try finding first by alternate URL 
        if ep.present? 
            redirect_to ep, :status => 301, :notice => "This page has moved permanently, but we found the destination. Please update your bookmarks and links."
        # Worst case search using URL keywords  
        else 
            keywords = params[:a].split('/').last.gsub(/-/, " ")
            redirect_to root_path(:search => keywords), :notice => "We couldn't find that page, so we searched for something similar."
        end  
    end 
end 
