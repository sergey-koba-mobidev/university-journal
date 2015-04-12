class AddRelationshipToAttends < ActiveRecord::Migration
  def change
    add_column :attends, :relationship_id, :integer
  end
end
