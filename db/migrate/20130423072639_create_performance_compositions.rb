class CreatePerformanceCompositions < ActiveRecord::Migration
  def change
    create_table :performance_compositions do |t|
			t.integer :performance_id
			t.integer :composition_id

      t.timestamps
    end

		add_index :performance_compositions, :performance_id
		add_index :performance_compositions, :composition_id
		add_index :performance_compositions, [:performance_id, :composition_id], unique: true, name: 'by_performance_compositions'
  end
end
