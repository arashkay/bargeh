class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :user_id
      t.integer :to_user_id
      t.integer :last_message_id
      t.boolean :user_viewed, :boolean, default: 0
      t.boolean :to_user_viewed, :boolean, default: 0

      t.timestamps
    end

    add_foreign_key :conversations, :users
    add_foreign_key :conversations, :users, column: 'to_user_id'
    add_foreign_key :conversations, :messages, column: 'last_message_id'

  end
end
