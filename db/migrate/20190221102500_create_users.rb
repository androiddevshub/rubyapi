class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :contact
      t.string :password_digest
      t.integer :otp
      t.string :forgot_password_token
      t.timestamps
    end
  end
end
