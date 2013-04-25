class AddCompositionIdToTitles < ActiveRecord::Migration
  def change
		add_column :titles, :composition_id, :integer
  end
end
