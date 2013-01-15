class ErrorsController < ApplicationController
    
    def routing         
        keywords = params[:a].split('/').last.gsub(/-/, " ")
        redirect_to root_path(:search => keywords), :alert => "We couldn't find that page, so we searched for something similar." 
    end 
end 
