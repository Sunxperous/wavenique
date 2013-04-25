class CreateYoutubes < ActiveRecord::Migration
  def change
    create_table :youtubes do |t|
			t.string :video_id

      t.timestamps
    end

		add_index :youtubes, :video_id
  end
end
