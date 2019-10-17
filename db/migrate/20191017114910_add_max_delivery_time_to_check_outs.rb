class AddMaxDeliveryTimeToCheckOuts < ActiveRecord::Migration[6.0]
  def change
    add_column :check_outs, :max_delivery_time, :string
  end
end
