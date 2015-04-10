module SemestersHelper
  def current_semester
    Semester.current
  end
end
