namespace :db do
  class String
    def pretty
      self.colorize(color: :light_green, background: :default)
    end
  end

  def create_semester_data(year, teacher)
    # Semester
    puts "\n== Creating semester"
    semester = Semester.create!(
        year: year,
        pos: (Time.zone.now.month<9) ? Semester.pos['spring'] : Semester.pos['autumn']
    )
    puts 'Semester created: '.pretty << semester.name

    # Group
    puts "\n== Creating group"
    group = Group.create!(
        title: '146',
        year: year,
    )
    puts 'Group created: '.pretty << group.title

    # Students
    puts "\n== Creating students"
    20.times do |n|
      name = "Student #{n+1}"
      email = "student#{n+1}@test.com"
      password = '12345678'
      student = User.find_or_create_by!(email: email) do |user|
        user.name = name
        user.password = password
        user.password_confirmation = password
      end
      group.users << student
    end
    puts 'Created 20 students in group '.pretty << group.title

    # Disciplines
    puts "\n== Creating disciplines"
    discipline1 = Discipline.find_or_create_by!(
        title: 'Web technologies and Wed design',
        user: teacher
    )
    disc1_rel = Relationship.create!(
        semester: semester,
        discipline: discipline1,
        group: group
    )
    puts 'Created discipline: '.pretty << discipline1.title
    discipline2 = Discipline.find_or_create_by!(
        title: 'Distributed technologies and parallel computing',
        user: teacher
    )
    disc2_rel = Relationship.create!(
        semester: semester,
        discipline: discipline2,
        group: group
    )
    puts 'Created discipline: '.pretty << discipline2.title

    # Labs
    puts "\n== Creating Labs"
    10.times do |n|
      Visit.create!(
          title: "Lab #{n+1}",
          relationship: disc1_rel,
          kind: Visit.kinds['lab'],
      )
    end
    puts 'Created labs for: '.pretty << discipline1.title
    10.times do |n|
      Visit.create!(
          title: "Lab #{n+1}",
          relationship: disc2_rel,
          kind: Visit.kinds['lab'],
      )
    end
    puts 'Created labs for: '.pretty << discipline2.title

    # Lectures
    puts "\n== Creating Lectures"
    10.times do |n|
      Visit.create!(
          title: "Lec #{n+1}",
          relationship: disc1_rel,
          kind: Visit.kinds['lecture'],
      )
    end
    puts 'Created lectures for: '.pretty << discipline1.title
    10.times do |n|
      Visit.create!(
          title: "Lec #{n+1}",
          relationship: disc2_rel,
          kind: Visit.kinds['lecture'],
      )
    end
    puts 'Created lectures for: '.pretty << discipline2.title

    # Modules
    puts "\n== Creating Modules"
    2.times do |n|
      Visit.create!(
          title: "Module #{n+1}",
          relationship: disc1_rel,
          kind: Visit.kinds['module'],
      )
    end
    puts 'Created modules for: '.pretty << discipline1.title
    2.times do |n|
      Visit.create!(
          title: "Module #{n+1}",
          relationship: disc2_rel,
          kind: Visit.kinds['module'],
      )
    end
    puts 'Created modules for: '.pretty << discipline2.title

    # Exams
    puts "\n== Creating Exams"
    Visit.create!(
        title: "Exam",
        relationship: disc1_rel,
        kind: Visit.kinds['exam'],
    )
    puts 'Created exam for: '.pretty << discipline1.title
    Visit.create!(
        title: "Exam",
        relationship: disc2_rel,
        kind: Visit.kinds['exam'],
    )
    puts 'Created exam for: '.pretty << discipline2.title

    # Homeworks
    puts "\n== Creating Homeworks"
    Visit.create!(
        title: "Homework",
        relationship: disc1_rel,
        kind: Visit.kinds['homework'],
    )
    puts 'Created homework for: '.pretty << discipline1.title
    Visit.create!(
        title: "Homework",
        relationship: disc2_rel,
        kind: Visit.kinds['homework'],
    )
    puts 'Created homework for: '.pretty << discipline2.title
  end

  desc 'Fill database with sample students'
  task populate_devdata: :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke

    # Admin
    puts "\n== Creating users"
    user = CreateAdminService.new.call
    puts "Created admin user : ".pretty << "#{user.email}/changeme"
    teacher = User.create!(name: 'Koba Sergii',
                           email: 'koba@example.com',
                           password: 'password',
                           password_confirmation: 'password')
    teacher.confirm!
    teacher.teacher!
    puts "Created teacher user : ".pretty << "#{teacher.email}/password"
    create_semester_data( Time.zone.now.year-1, teacher)
    create_semester_data( Time.zone.now.year, teacher)
  end
end