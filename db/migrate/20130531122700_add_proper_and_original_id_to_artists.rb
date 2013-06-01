class AddProperAndOriginalIdToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :proper, :boolean
    add_column :artists, :original_id, :integer

    add_index :artists, :original_id
  end
end
