class AddSumsToArgument < ActiveRecord::Migration
  def change
    add_column :arguments, :pros_sum, :decimal, default: 0
    add_column :arguments, :cons_sum, :decimal, default: 0
    add_column :arguments, :all_sum, :decimal, default: 0
    add_column :arguments, :min_sum, :decimal, default: 0
  end
end
