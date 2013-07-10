class CreateArtistAliases < ActiveRecord::Migration
  def change
    create_table :artist_aliases do |t|
      t.string :name
      t.integer :artist_id

      t.timestamps
    end
  end
end
