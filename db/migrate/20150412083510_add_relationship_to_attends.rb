class AddRelationshipToAttends < ActiveRecord::Migration[5.2]
  def change
    add_column :attends, :relationship_id, :integer
  end
end
