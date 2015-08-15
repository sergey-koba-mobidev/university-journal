module RelationshipsHelper
  def mark_by_total(total)
    case total
      when 90..101
        '5'
      when 75..90
        '4'
      when 60..75
        '3'
      else
        '2'
    end
  end

  def ects_by_total(total)
    case total
      when 90..101
        'A'
      when 83..90
        'B'
      when 75..83
        'C'
      when 68..75
        'D'
      when 60..68
        'E'
      when 35..60
        'FX'
      else
        'F'
    end
  end

  def cache_key_for_relationship(relationship)
    semester = relationship.semester
    discipline = relationship.discipline
    group = relationship.group
    "relationship/#{relationship.id}-#{relationship.updated_at}-#{semester.id}-#{semester.updated_at}-#{discipline.id}-#{discipline.updated_at}-#{group.id}-#{group.updated_at}"
  end
end
