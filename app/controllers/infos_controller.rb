class InfosController < ApplicationController

  before_filter :check_permission, :only => [:admin]
  
  def about
  end
  
  def admin   
    @users = User.order("id DESC").all 
  end

  def we_buy
  end
  
  protected 
  
  def check_permission      
    redirect_to root_path, :alert => "You must be admin to view the admin page." if (current_user.nil? or not current_user.admin?)
  end
end
