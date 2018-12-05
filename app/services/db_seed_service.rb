class DbSeedService
  def call
    admin = CreateAdminService.new.call

    student = User.find_or_create_by!(email: "student@journal.com") do |user|
      user.name = "Student 1"
      user.password = "12345678"
      user.password_confirmation = "12345678"
      user.student!
    end

    group = Group.find_or_create_by!(title: "137", year: Time.zone.now.year)
    group.users << student if group.users.size == 0

    semester = Semester.find_or_create_by!(year: Time.zone.now.year, pos: (Time.zone.now.month<8) ? Semester.pos['spring'] : Semester.pos['autumn'])

    discipline = Discipline.find_or_create_by!(title: "Web technologies and web design", user_id: admin.id)

    relationship = Relationship.find_or_create_by!(semester_id: semester.id, discipline_id: discipline.id, group_id: group.id)
    module_1_visit = Visit.find_or_create_by!(title: "Module 1", relationship_id: relationship.id, kind: :module)
    module_2_visit = Visit.find_or_create_by!(title: "Module 2", relationship_id: relationship.id, kind: :module)

    module1 = DisciplineModule.find_or_create_by!(title: "HTML and CSS", discipline_id: discipline.id, duration: 3600)
  end
end
