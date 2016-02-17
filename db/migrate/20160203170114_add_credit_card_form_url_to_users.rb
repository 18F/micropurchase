class AddCreditCardFormUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit_card_form_url, :string
  end
end
