require_relative 'app'

def option_list
  puts ''
  puts '1 - List all books.'
  puts '2 - List all people'
  puts '3 - Create a person'
  puts '4 - Create a book'
  puts '5 - Create a rental'
  puts '6 - List all rentals for a given person id'
  puts '7 - Exit'
end

def create_person(app)
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
  when 1
    app.create_student(age, name, parent_permission: parent_permission)
  when 2
    puts 'Specialization:'
    specialization = gets.chomp
    app.create_teacher(age, specialization, name, parent_permission)
  else
    puts 'Invalid option'
  end
end

def option_handel(option, app)
  case option
  when 3
    create_person(app)
  when 4
    app.create_book
  when 5
    app.create_rental
  when 6
    puts 'Enter ID:'
    id = gets.chomp.to_i
    app.list_rentals(id)
  when 7
    puts 'Thanks for using the app!'
    exit
  else
    puts 'Invalid option'
  end
  true
end

def main
  status = true
  app = App.new
  while status
    option_list
    option = gets.chomp.to_i
    if option == '1'
      app.list_all_books
    elsif option == '2'
    app.list_all_peoples
    else
      status = option_handel(option, app)
    end
  end
end

main