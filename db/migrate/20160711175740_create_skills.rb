class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.timestamps null: false
      t.string :name
    end

    add_index :skills, :name, unique: true

    create_join_table :auctions, :skills
  end
end
