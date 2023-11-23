require_relative 'app'
require_relative 'menu_handler'
require_relative 'people_handler'
require_relative 'book_handler'
require_relative 'rental_handler'

class MainApp
  def initialize
    @app = App.new
    @people_handler = PeopleHandler.new(@app)
    @menu_handler = MenuHandler.new(@app, @people_handler)
    @book_handler = BookHandler.new(@app)
    @rental_handler = RentalHandler.new(@app)
  end

  def start
    while @menu_handler.display_menu
      option = gets.chomp.to_i
      @menu_handler.handle_option(option)
    end
  end
end

MainApp.new.start
