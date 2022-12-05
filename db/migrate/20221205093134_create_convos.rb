class CreateConvos < ActiveRecord::Migration[7.0]
  def change
    create_table :convos do |t|
      t.integer :sender_id
      t.integer :receiver_id

      t.timestamps
    end
  end
end
