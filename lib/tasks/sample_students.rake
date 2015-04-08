namespace :db do
  desc 'Fill database with sample students'
  task populate_devdata: :environment do
    Rake::Task['db:setup'].invoke

    # Admin
    user = CreateAdminService.new.call
    puts 'Created admin users: ' << user.email

    # Semester
    semester = Semester.create!(
      year: Time.zone.now.year,
      pos: (Time.zone.now.month<9) ? Semester.pos['spring'] : Semester.pos['autumn']
    )
    puts 'Semester created: ' << semester.name

    # Group
    group = Group.create!(
        title: '146',
        year: Time.zone.now.year,
    )
    puts 'Group created: ' << group.title

    # Students
    20.times do |n|
      name = "Student #{n+1}"
      email = "student#{n+1}@test.com"
      password = '12345678'
      student = User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
      group.users << student
    end
    puts 'Created 20 students in group ' << group.title
  end
end