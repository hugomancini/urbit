class AddFreeUrbitToCheckOuts < ActiveRecord::Migration[6.0]
  def change
    add_column :check_outs, :free_urbit, :boolean
  end
end
