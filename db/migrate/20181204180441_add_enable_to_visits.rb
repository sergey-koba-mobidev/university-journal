class AddEnableToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :enabled, :boolean
    add_column :visits, :object_id, :integer
  end
end
