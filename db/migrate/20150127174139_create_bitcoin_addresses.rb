class CreateBitcoinAddresses < ActiveRecord::Migration
  def change
    create_table :bitcoin_addresses do |t|
      t.string :bitcoin_address, unique: true
      t.decimal :balance, default: 0

      t.timestamps
    end
  end
end
