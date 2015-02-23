class CreateAttends < ActiveRecord::Migration
  def change
    create_table :attends do |t|
      t.references :visit, index: true
      t.references :user, index: true
      t.integer :mark
      t.integer :mark_ects
      t.integer :presence

      t.timestamps null: false
    end
    add_foreign_key :attends, :visits
    add_foreign_key :attends, :users
  end
end
