class RentalHandler
  def initialize(app)
    @app = app
  end

  def create_rental
    @app.create_rental
  end

  def list_rentals(_person_id)
    puts 'Enter ID:'
    id = gets.chomp.to_i
    @app.list_rentals(id)
  end
end
