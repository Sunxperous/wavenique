class AddOriginalIdAndProperToCompositions < ActiveRecord::Migration
  def change
    add_column :compositions, :original_id, :integer
    add_column :compositions, :proper, :string

    add_index :compositions, :original_id
  end
end
