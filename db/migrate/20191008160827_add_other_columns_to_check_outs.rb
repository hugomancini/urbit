class AddOtherColumnsToCheckOuts < ActiveRecord::Migration[6.0]
  def change
    add_column :check_outs, :u_cart_id, :string
    add_column :check_outs, :u_checkout_id, :string
  end
end
