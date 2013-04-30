class AddColumnsToCompositionsAndArtists < ActiveRecord::Migration
  def change
    add_column :compositions, :title, :string
    add_column :artists, :name, :string

    add_index :compositions, :title
    add_index :artists, :name
  end
end
