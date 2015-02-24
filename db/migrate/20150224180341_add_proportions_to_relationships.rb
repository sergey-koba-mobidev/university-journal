class AddProportionsToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :proportions, :string
  end
end
