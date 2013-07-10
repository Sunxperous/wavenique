class ModifyArtistAndArtistAliasColumns < ActiveRecord::Migration
  def up
    remove_column :artists, :proper
    remove_column :artists, :name
    remove_index :artists, :name
  end

  def down
    add_column :artists, :proper, :boolean
    add_column :artists, :name, :string
  end

  def change
    add_column :artist_aliases, :proper, :integer
    add_index :artist_aliases, [:artist_id, :name], unique: true
  end
end
