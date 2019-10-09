class AddMoreColumnsToCheckOuts < ActiveRecord::Migration[6.0]
  def change
    add_column :check_outs, :email, :string
    add_column :check_outs, :address_2, :string
  end
end
