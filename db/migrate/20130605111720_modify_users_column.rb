class ModifyUsersColumn < ActiveRecord::Migration
  def change
    remove_column :users, :google_id
    remove_column :users, :google_name
    remove_column :users, :google_access_token
    remove_column :users, :google_refresh_token
    remove_column :users, :youtube_channel

    add_column :users, :name, :string
  end

  def down
    add_column :users, :google_id, :string
    add_column :users, :google_name, :string
    add_column :users, :google_access_token, :string
    add_column :users, :google_refresh_token, :string
    add_column :users, :youtube_channel, :string
    
    remove_column :users, :name
  end
end
