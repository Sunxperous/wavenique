class AddUniqueIndexToYoutubes < ActiveRecord::Migration
  def change
		remove_index :youtubes, :video_id
		add_index :youtubes, :video_id, unique: true
  end
end
