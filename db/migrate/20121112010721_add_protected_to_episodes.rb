class AddProtectedToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :protected, :boolean
  end
end
