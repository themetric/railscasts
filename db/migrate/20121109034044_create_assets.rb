class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.integer :assetable_id
      t.string  :assetable_type
      t.integer :position
      t.has_attached_file :attachment
      t.timestamps
    end
  end
end
