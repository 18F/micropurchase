class AddContractingOfficerToUsers < ActiveRecord::Migration
  def change
    add_column(
      :users,
      :contracting_officer,
      :boolean,
      null: false,
      default: false
    )

    add_index :users, :contracting_officer, where: "contracting_officer = true"
  end
end
