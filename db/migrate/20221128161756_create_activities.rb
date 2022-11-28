class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.string :title
      t.text :description
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :url
      t.integer :price_cents
      t.integer :open_days
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :workshop
      t.datetime :open_hour
      t.datetime :closing_hour
      t.string :age_range
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
