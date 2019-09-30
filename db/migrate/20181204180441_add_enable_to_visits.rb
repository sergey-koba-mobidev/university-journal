class AddEnableToVisits < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :enabled, :boolean
    add_column :visits, :object_id, :integer
  end
end
