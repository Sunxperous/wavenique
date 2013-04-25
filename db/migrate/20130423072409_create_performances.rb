class CreatePerformances < ActiveRecord::Migration
  def change
    create_table :performances do |t|
			t.integer :youtube_id

      t.timestamps
    end

		add_index :performances, :youtube_id
  end
end
