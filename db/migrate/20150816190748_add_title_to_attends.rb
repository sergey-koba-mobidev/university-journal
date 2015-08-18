class AddTitleToAttends < ActiveRecord::Migration
  def change
    add_column :attends, :title, :string
  end
end
