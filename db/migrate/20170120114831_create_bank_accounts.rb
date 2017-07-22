class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :username, unique: true, null: false, index: true

      t.timestamps null: false
    end
  end
end
