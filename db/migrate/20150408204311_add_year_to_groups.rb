class AddYearToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :year, :integer
  end
end
