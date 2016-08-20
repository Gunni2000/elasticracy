class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.text :topic
      t.datetime :due

      t.timestamps null: false
    end
  end
end
