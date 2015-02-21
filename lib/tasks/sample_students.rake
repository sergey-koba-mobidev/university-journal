namespace :db do
  desc 'Fill database with sample students'
  task populate_students: :environment do

    20.times do |n|
      name = "Student #{n+1}"
      email = "student#{n+1}@test.com"
      password = '12345678'
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end