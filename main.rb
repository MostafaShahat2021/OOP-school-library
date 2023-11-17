require_relative 'app'

class MainApp
  MENU_OPTIONS = {
    1 => :list_all_books,
    2 => :list_all_peoples,
    3 => :create_person,
    4 => :create_book,
    5 => :create_rental,
    6 => :list_rentals,
    7 => :exit_app
  }.freeze

  def initialize
    @app = App.new
  end

  def start
    while menu
      option = gets.chomp.to_i
      handle_option(option)
    end
  end

  private

  def menu
    puts '1 - List all books.'
    puts '2 - List all people'
    puts '3 - Create a person'
    puts '4 - Create a book'
    puts '5 - Create a rental'
    puts '6 - List all rentals for a given person id'
    puts '7 - Exit'
    true
  end

  def handle_option(option)
    selected_option = MENU_OPTIONS[option]

    if selected_option
      send(selected_option)
    else
      puts 'Invalid option'
    end
  end

  def list_all_books
    @app.list_all_books
  end

  def list_all_peoples
    @app.list_all_peoples
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
    when 1 then @app.create_student(age, name, parent_permission: parent_permission)
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

  def create_book
    @app.create_book
  end

  def create_rental
    @app.create_rental
  end

  def list_rentals
    puts 'Enter ID:'
    id = gets.chomp.to_i
    @app.list_rentals(id)
  end

  def exit_app
    puts 'Thanks for using the app!'
    false
  end
end

MainApp.new.start
