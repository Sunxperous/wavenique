class RemoveNameFromArtists < ActiveRecord::Migration
  def up
    remove_index :artists, :name
    remove_column :artists, :proper
    remove_column :artists, :name
  end

  def down
    add_column :artists, :proper, :boolean
    add_column :artists, :name, :string
  end
end
