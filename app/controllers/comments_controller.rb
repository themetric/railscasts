class CommentsController < ApplicationController
  load_and_authorize_resource

  def index
    @comments = @comments.search(params[:comment_search]).recent.paginate(:page => params[:page], :per_page => 50)
  end

  def new
    @comment = Comment.new(:parent_id => params[:parent_id], :episode_id => params[:episode_id], :user => current_user)
  end

  def create
    @comment = current_user.comments.build(params[:comment])
    @comment.request = request
    @comment.save
    respond_to do |format|
      format.html do
        if @comment.errors.present?
          render :new
        else
          @comment.notify_other_commenters
          redirect_to(episode_path(@comment.episode, :view => "comments"))
        end
      end
      format.js
    end
  end

  def edit
  end

  def update
    @comment.update_attributes(params[:comment])
    respond_to do |format|
      format.html do
        if @comment.errors.present?
          render :edit
        else
          redirect_to(episode_path(@comment.episode, :view => "comments"))
        end
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
     if @comment.destroy
        flash[:notice] = "Deleted comment. #{undo_link}"
        format.js 
        format.html { redirect_to episode_path(@comment.episode, :view => "comments") }              
     else
        flash[:error] = "Your comment could not be deleted" 
     end 
    end
  end

  private

  def undo_link
    if can? :revert, :versions
      version = @comment.versions.scoped.last
      view_context.link_to("undo", revert_version_path(version), :method => :post) if can? :revert, version
    end
  end
end
