class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.string :title
      t.references :relationship, index: true
      t.integer :type

      t.timestamps null: false
    end
    add_foreign_key :visits, :relationships
  end
end
