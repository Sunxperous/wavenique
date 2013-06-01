class CreatePerformanceTags < ActiveRecord::Migration
  def change
    create_table :performance_tags do |t|
      t.integer :tag_id
      t.integer :performance_id

      t.timestamps
    end

    add_index :performance_tags, [:tag_id, :performance_id], unique: true
  end
end
