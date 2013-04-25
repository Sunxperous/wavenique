class CreateNames < ActiveRecord::Migration
  def change
    create_table :names do |t|
			t.integer :artist_id
			t.string :name

      t.timestamps
    end
		
		add_index :names, :name
  end
end
