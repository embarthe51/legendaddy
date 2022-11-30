class RemoveOpenDaysFromActivity < ActiveRecord::Migration[7.0]
  def change
    remove_column :activities, :open_days, :integer
  end
end
