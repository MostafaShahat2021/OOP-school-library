class MenuHandler
  MENU_OPTIONS = {
    1 => :list_all_books,
    2 => :list_all_peoples,
    3 => :create_person,
    4 => :create_book,
    5 => :create_rental,
    6 => :list_rentals,
    7 => :exit_app
  }.freeze

  def initialize(app, people_handler)
    @app = app
    @people_handler = people_handler
  end

  def display_menu
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

    case selected_option
    when :list_all_peoples then @people_handler.list_all_peoples
    when :create_person then @people_handler.create_person
    when :list_all_books, :create_book, :create_rental, :list_rentals, :exit_app
      if selected_option == :list_rentals
        list_rentals_prompt
      else
        @app.send(selected_option)
      end
    else
      puts 'Invalid option'
    end
  end

  private

  def list_rentals_prompt
    loop do
      puts 'Enter ID (or type "exit" to return to the main menu):'
      input = gets.chomp
      break if input.downcase == 'exit'

      begin
        person_id = Integer(input)
        @app.list_rentals(person_id)
        break
      rescue ArgumentError
        puts 'Invalid input. Please enter a valid ID or type "exit".'
      end
    end
  end
end
