class UsersController < ApplicationController
  before_filter :load_current_user, :only => [:edit, :update]
  load_and_authorize_resource

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    @user.attributes = params[:user]
    @user.save!
    redirect_to @user, :notice => "Successfully updated profile."
  end

  def ban
    @user = User.find(params[:id])
    @user.update_attribute(:banned_at, Time.now)
    @comments = @user.comments
    @comments.each(&:destroy)
    respond_to do |format|
      format.html { redirect_to :back, :notice => "User #{@user.name} has been banned." }
      format.js
    end
  end

  def unsubscribe
    @user = User.find_by_unsubscribe_token!(params[:token])
    @user.update_attributes!(:email_on_reply => false)
    redirect_to root_url, :notice => "You have been unsubscribed from further email notifications."
  end

  private

  def load_current_user
    @user = current_user
  end
end
