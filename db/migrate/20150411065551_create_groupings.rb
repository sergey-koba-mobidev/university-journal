class CreateGroupings < ActiveRecord::Migration[5.2]
  def change
    create_table :groupings do |t|
      t.references :user, index: true
      t.references :group, index: true

      t.timestamps null: false
    end
    add_foreign_key :groupings, :users
    add_foreign_key :groupings, :groups
  end
end
