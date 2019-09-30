class AddStatusToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :status, :integer
    add_index :groups, :status
  end
end
