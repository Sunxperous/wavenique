class CreatePerformanceArtists < ActiveRecord::Migration
  def change
    create_table :performance_artists do |t|
			t.integer :performance_id
			t.integer :artist_id

      t.timestamps
    end

		add_index :performance_artists, :performance_id
		add_index :performance_artists, :artist_id
		add_index :performance_artists, [:performance_id, :artist_id], unique: true, name: 'by_performance_artists'
  end
end
