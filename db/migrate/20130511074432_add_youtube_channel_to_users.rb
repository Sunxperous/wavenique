class AddYoutubeChannelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :youtube_channel, :string
    add_index :users, :youtube_channel
  end
end
