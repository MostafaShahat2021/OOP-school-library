class BookHandler
  def initialize(app)
    @app = app
  end

  def create_book
    @app.create_book
  end

  def list_all_books
    @app.list_all_books
  end
end