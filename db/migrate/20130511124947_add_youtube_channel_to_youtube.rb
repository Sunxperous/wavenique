class AddYoutubeChannelToYoutube < ActiveRecord::Migration
  def change
    add_column :youtubes, :channel_id, :string
    add_index :youtubes, :channel_id
  end
end
