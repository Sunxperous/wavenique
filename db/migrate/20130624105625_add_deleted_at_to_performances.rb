class AddDeletedAtToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :deleted_at, :datetime
  end
end
