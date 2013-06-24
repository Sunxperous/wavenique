class AddPolymorphismToPerformances < ActiveRecord::Migration
  def change
    remove_column :performances, :youtube_id
    add_column :performances, :wave_id, :integer
    add_column :performances, :wave_type, :string
  end
end
