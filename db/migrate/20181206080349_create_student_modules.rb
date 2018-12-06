class CreateStudentModules < ActiveRecord::Migration
  def change
    create_table :student_modules do |t|
      t.references :visit, index: true
      t.references :user, index: true
      t.integer :status
      t.jsonb :questions
      t.jsonb :answers
      t.jsonb :results
      t.integer :total
      t.timestamp :opened_until

      t.timestamps null: false
    end
  end
end
