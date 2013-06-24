class AddWaveIndexToPerformances < ActiveRecord::Migration
  def change
    add_index :performances, [:wave_id, :wave_type]
  end
end
