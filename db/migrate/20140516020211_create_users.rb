class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :number
      t.string :verification_code
      t.datetime :verified_at
      t.string :username
      t.string :authentication_token
      t.string :user_type

      t.timestamps
    end
  end
end
