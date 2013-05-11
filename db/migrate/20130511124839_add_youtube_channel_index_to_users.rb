class AddYoutubeChannelIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :youtube_channel
  end
end
