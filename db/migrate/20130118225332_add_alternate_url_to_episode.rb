class AddAlternateUrlToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :alternate_url, :string 
  end
end
