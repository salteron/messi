class CreateDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :deliveries do |t|
      t.references :message, foreign_key: true, null: false
      t.string :message_text_md5, null: false
      t.integer :recipient_messenger, null: false
      t.string :recipient_messenger_user_id, null: false
      t.timestamps null: false
    end

    add_index :deliveries, %i[
      recipient_messenger
      recipient_messenger_user_id
      message_text_md5
    ], unique: true, name: :uniq_idx_deliveries_on_recipient_and_text
  end
end
