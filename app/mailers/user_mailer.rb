class UserMailer < ApplicationMailer

  def new_homework_email(homework)
    @student = homework.user
    @teacher = homework.visit.relationship.discipline.user
    @homework = homework
    mail(to: @teacher.email, subject: 'New Homework uploaded')
  end

  def new_correction_email(homework)
    @student = homework.user
    @teacher = homework.visit.relationship.discipline.user
    @homework = homework
    mail(to: @student.email, subject: 'New Corrections to Homework')
  end
end
