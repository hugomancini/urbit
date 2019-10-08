class CreateCheckOuts < ActiveRecord::Migration[6.0]
  def change
    create_table :check_outs do |t|
      t.string :cart_token
      t.string :fees
      t.string :valid_address
      t.string :delivery_time
      t.string :message

      t.timestamps
    end
  end
end
