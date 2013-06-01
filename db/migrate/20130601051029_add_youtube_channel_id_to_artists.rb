class AddYoutubeChannelIdToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :youtube_channel_id, :string
    add_index :artists, :youtube_channel_id, unique: true
  end
end
