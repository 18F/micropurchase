class Bidders < ActiveRecord::Migration
  def change
    create_table :bidders do |t|
      t.string :github_id
      t.string :duns_id
      t.string :sam_id
      t.timestamps null: false
    end
  end
end
