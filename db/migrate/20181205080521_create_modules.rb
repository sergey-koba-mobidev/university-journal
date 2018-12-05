class CreateModules < ActiveRecord::Migration
  def change
    create_table :discipline_modules do |t|
      t.string :title
      t.references :discipline, index: true
      t.integer :duration

      t.timestamps null: false
    end
  end
end
