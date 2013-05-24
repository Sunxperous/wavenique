class RemoveUnlinkedAndAddIndexes < ActiveRecord::Migration
  def up
    remove_column :performances, :unlinked
  end

  def down
    add_column :performances, :unlinked, :boolean
  end
end
