class AddProportionsToRelationships < ActiveRecord::Migration[5.2]
  def change
    add_column :relationships, :proportions, :string
  end
end
