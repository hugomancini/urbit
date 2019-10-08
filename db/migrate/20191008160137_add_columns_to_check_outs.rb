class AddColumnsToCheckOuts < ActiveRecord::Migration[6.0]
  def change
    add_column :check_outs, :address_1, :string
    add_column :check_outs, :first_name, :string
    add_column :check_outs, :last_name, :string
    add_column :check_outs, :city, :string
    add_column :check_outs, :postcode, :string
    add_column :check_outs, :phone_number, :string
  end
end
