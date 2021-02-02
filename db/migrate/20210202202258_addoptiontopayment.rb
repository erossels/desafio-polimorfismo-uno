class Addoptiontopayment < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :option, :string
  end
end
