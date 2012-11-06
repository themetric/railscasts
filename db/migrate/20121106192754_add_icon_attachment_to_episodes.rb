class AddIconAttachmentToEpisodes < ActiveRecord::Migration
  def change
    add_attachment :episodes, :icon 
  end
end
