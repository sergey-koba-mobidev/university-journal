class AddStatusToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :status, :integer
    add_index :groups, :status
  end
end
