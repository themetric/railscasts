class AssetsController < ApplicationController
  def show
    @asset = Asset.find(params[:id])
  end

  def create
    newparams = coerce(params)
    @asset = Asset.new(newparams[:asset])

    if @asset.save
      flash[:notice] = "Successfully created upload."
      respond_to do |format|
        format.json {render :json => { :result => 'success', :asset_id => @asset.id } }
      end
    else
      respond_to do |format|
        format.json {
          render :json => { :result => 'failed' }, :status => 500 
        }
      end
    end
  end

  def destroy
    @episode = Episode.find(params[:episode_id])
    @asset = @episode.assets.find(params[:id])    
    
    if @asset.destroy
        respond_to do |format|          
          format.js
        end
    end 
  end

  private 
  def coerce(params)
    if params[:asset].nil? 
      h = Hash.new 
      h[:asset] = Hash.new 
      h[:asset][:assetable_id] = params[:assetable_id] 
      h[:asset][:assetable_type] = params[:assetable_type] 
      h[:asset][:attachment] = params[:Filedata] 
      h[:asset][:attachment].content_type = MIME::Types.type_for(h[:asset][:attachment].original_filename).to_s
      h
    else 
      params
    end 
  end
end
