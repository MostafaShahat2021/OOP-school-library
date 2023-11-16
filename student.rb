require_relative 'person'

class Student < Person
  # Remove the redundant definition of classroom= to fix rubocop  error
  # attr_accessor :classroom

  def initialize(age, name = 'Unknown', parent_permission: true)
    super(age, name: name, parent_permission: parent_permission)
  end

  def play_hooky
    '¯\(ツ)/¯'
  end

  def classroom=(classroom)
    @classroom = classroom
    @classroom.students.push(self) unless classroom.students.include?(self)
  end
end
