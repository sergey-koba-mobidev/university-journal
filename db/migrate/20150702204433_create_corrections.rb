class CreateCorrections < ActiveRecord::Migration
  def change
    create_table :corrections do |t|
      t.references :user, index: true
      t.references :homework, index: true
      t.text :body

      t.timestamps null: false
    end
    add_foreign_key :corrections, :users
    add_foreign_key :corrections, :homeworks
  end
end
