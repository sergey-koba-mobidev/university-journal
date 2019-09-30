class ChangeMarkToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :attends, :mark, :float
  end
end
