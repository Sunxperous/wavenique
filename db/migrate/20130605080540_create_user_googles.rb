class CreateUserGoogles < ActiveRecord::Migration
  def change
    create_table :user_googles do |t|
      t.string :access_token
      t.string :refresh_token
      t.integer :user_id
      t.string :site_id

      t.timestamps
    end

    add_index :user_googles, :user_id, unique: true
    add_index :user_googles, :site_id, unique: true
  end
end
