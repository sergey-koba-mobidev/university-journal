class CreateHomeworks < ActiveRecord::Migration[5.2]
  def change
    create_table :homeworks do |t|
      t.references :attend, index: true
      t.text :comment_text

      t.timestamps null: false
    end
    add_foreign_key :homeworks, :attends
    add_attachment :homeworks, :document
  end
end
