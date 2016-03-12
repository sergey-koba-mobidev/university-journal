class ChangeMarkToFloat < ActiveRecord::Migration
  def change
    change_column :attends, :mark, :float
  end
end
