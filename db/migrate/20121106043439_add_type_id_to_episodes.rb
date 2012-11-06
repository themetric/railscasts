class AddTypeIdToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :type_id, :integer 
  end
end
