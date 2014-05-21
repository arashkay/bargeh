class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :to_user_id
      t.text :body
      t.boolean :is_viewed, default: 0

      t.timestamps
    end

    add_foreign_key :messages, :users
    add_foreign_key :messages, :users, column: 'to_user_id'

  end
end
