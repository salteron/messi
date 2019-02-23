class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :text, null: false
      t.timestamp :send_at
      t.timestamps null: false
    end
  end
end
