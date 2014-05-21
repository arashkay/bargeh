class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :user_id, null: false
      t.string :device_id
      t.string :device_type, null: false
      t.text :notification_id
      t.boolean :can_notify, default: 1

      t.timestamps
    end

    add_foreign_key :devices, :users

  end
end
