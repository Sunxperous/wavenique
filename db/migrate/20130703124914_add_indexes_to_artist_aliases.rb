class AddIndexesToArtistAliases < ActiveRecord::Migration
  def change
    add_index :artist_aliases, :name
    add_index :artist_aliases, :artist_id
  end
end
