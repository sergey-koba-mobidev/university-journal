class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.references :semester, index: true
      t.references :discipline, index: true
      t.references :group, index: true

      t.timestamps null: false
    end
    add_foreign_key :relationships, :semesters
    add_foreign_key :relationships, :disciplines
    add_foreign_key :relationships, :groups
  end
end
