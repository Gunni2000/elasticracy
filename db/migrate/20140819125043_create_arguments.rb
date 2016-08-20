class CreateArguments < ActiveRecord::Migration
  def change
    create_table :arguments do |t|
      t.text :statement
      t.integer :validity
      t.references :topic, index: true, foreign_key: true, :null => false

      t.timestamps null: false
    end
  end
end
