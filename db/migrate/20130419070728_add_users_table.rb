class AddUsersTable < ActiveRecord::Migration
  def up
		create_table :users do |t|
			t.string :google_id
			t.string :google_name
			t.string :google_refresh_token
			t.string :remember_token
		end

		add_index :users, :remember_token
  end

	def down
		drop_table :users
	end
end
