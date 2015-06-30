class CreateHomeworks < ActiveRecord::Migration
  def change
    create_table :homeworks do |t|
      t.references :attend, index: true
      t.string :document

      t.timestamps null: false
    end
    add_foreign_key :homeworks, :attends
  end
end
