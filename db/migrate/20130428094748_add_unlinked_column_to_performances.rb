class AddUnlinkedColumnToPerformances < ActiveRecord::Migration
  def change
		add_column :performances, :unlinked, :boolean
  end
end
