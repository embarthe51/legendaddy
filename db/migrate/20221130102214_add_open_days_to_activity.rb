class AddOpenDaysToActivity < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :open_days, :integer, array: true, default: []
  end
end
