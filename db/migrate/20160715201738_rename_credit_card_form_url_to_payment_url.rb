class RenameCreditCardFormUrlToPaymentUrl < ActiveRecord::Migration
  def change
    rename_column :users, :credit_card_form_url, :payment_url
  end
end
