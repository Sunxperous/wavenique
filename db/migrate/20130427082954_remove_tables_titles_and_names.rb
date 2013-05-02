class RemoveTablesTitlesAndNames < ActiveRecord::Migration
  def up
    drop_table :titles
    drop_table :names
  end

  def down
    create_table :titles do |t|
      t.integer :composition_id
      t.string :title
    end

    create_table :names do |t|
      t.integer :artist_id
      t.string :name
    end
  end
end
