class RenameTagToLabel < ActiveRecord::Migration
  def up
    drop_table :tags
    drop_table :performance_tags

    create_table :labels do |t|
      t.string :name
    end

    create_table :performance_labels do |t|
      t.integer :performance_id
      t.integer :label_id
    end

    add_index :performance_labels, [:label_id, :performance_id]
  end

  def down
    drop_table :labels
    drop_table :performance_labels

    create_table :tags do |t|
      t.string :name
    end
    
    create_table :performance_tags do |t|
      t.integer :performance_id
      t.integer :tag_id
    end

    add_index :performance_tags, [:tag_id, :performance_id]
  end
end
