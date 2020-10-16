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
    module_1_visit = Visit.find_or_create_by!(title: "Module 1", relationship_id: relationship.id, kind: :module, enabled: true)
    module_2_visit = Visit.find_or_create_by!(title: "Module 2", relationship_id: relationship.id, kind: :module)

    module1 = DisciplineModule.find_or_create_by!(title: "HTML and CSS", discipline_id: discipline.id, duration: 3600)
    module_1_visit.update_attribute(:object_id, module1.id)
    question_group1 = QuestionGroup.find_or_create_by!(title: "HTML", discipline_module_id: module1.id, position: 1, points: 2)
    question_group2 = QuestionGroup.find_or_create_by!(title: "CSS", discipline_module_id: module1.id, position: 2, points: 2)
    question_group3 = QuestionGroup.find_or_create_by!(title: "CSS3", discipline_module_id: module1.id, position: 3, points: 2)
    
    Question.find_or_create_by!(description: "Write an example of html form", question_group_id: question_group1.id, kind: Question.kinds['text'], answer: "", variants: "[]")
    Question.find_or_create_by!(description: "Write an example of html table", question_group_id: question_group1.id, kind: Question.kinds['text'], answer: "", variants: "[]")

    Question.find_or_create_by!(description: "Choose CSS property to set text color", question_group_id: question_group2.id, kind: Question.kinds['one'], answer: "1", variants: ["style", "color", "text-color"])
    Question.find_or_create_by!(description: "Choose CSS property to set width of block", question_group_id: question_group2.id, kind: Question.kinds['one'], answer: "2", variants: ["size", "height", "width"])

    Question.find_or_create_by!(description: "Choose properties introduced in CSS 3", question_group_id: question_group3.id, kind: Question.kinds['many'], answer: "[1,2]", variants: ["text-shadow", "animation", "text-size"])
  end
end
