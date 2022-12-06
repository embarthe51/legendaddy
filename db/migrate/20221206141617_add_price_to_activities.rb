class AddPriceToActivities < ActiveRecord::Migration[7.0]
  def change
    remove_column :activities, :price_cents, :integer
    add_column :activities, :price, :string
  end
end
