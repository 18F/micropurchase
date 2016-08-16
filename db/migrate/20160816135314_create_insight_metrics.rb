class CreateInsightMetrics < ActiveRecord::Migration
  def change
    create_table :insight_metrics do |t|
      t.timestamps null: false
      t.string :statistic, null: false
      t.string :label, null: false
      t.string :name, null: false
      t.string :href, null: false, default: ''
      t.string :label_statistic, null: false, default: ''
    end

    add_index :insight_metrics, :name
  end
end
