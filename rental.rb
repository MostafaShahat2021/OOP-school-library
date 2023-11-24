class Rental
  attr_accessor :date, :book, :person

  def initialize(book, person, date)
    @date = date
    @book = book
    @person = person

    # Make sure book and person are not nil before manipulating their rentals
    @book.rentals << self if @book
    @person.rentals << self if @person
  end

  def to_h
    {
      'book' => { 'title' => @book.title, 'author' => @book.author },
      'person_id' => @person.id,
      'date' => @date
    }
  end
end
