class PeopleHandler
  def initialize(app)
    @app = app
  end

  def create_person
    puts 'Do you want to create a student(1) or a teacher(2)? [Input number]:'
    option = gets.chomp
    parent_permission = true
    puts 'Age:'
    age = gets.chomp.to_i
    puts 'Name:'
    name = gets.chomp
    puts 'Parent permission? [Y/N]:'
    value = gets.chomp
    parent_permission = false if %w[N n NO No no].include?(value)

    case option.to_i
    when 1 then create_student(age, name, parent_permission)
    when 2 then create_teacher(age, name, parent_permission)
    else
      puts 'Invalid option'
    end
  end

  def create_teacher(age, name, parent_permission)
    puts 'Specialization:'
    specialization = gets.chomp
    @app.create_teacher(age, specialization, name, parent_permission)
  end

  def create_student(age, name, parent_permission)
    @app.create_student(age, name, parent_permission: parent_permission)
  end

  def list_all_peoples
    @app.list_all_peoples
  end
  
end
