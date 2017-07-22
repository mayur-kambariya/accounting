class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :amount
      t.references :bank_account, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
