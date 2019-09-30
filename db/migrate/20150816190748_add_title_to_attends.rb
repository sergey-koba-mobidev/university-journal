class AddTitleToAttends < ActiveRecord::Migration[5.2]
  def change
    add_column :attends, :title, :string
  end
end
