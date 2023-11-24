class Rental
  attr_accessor :date, :book, :person

  def initialize(book, person, date)
    @date = date
    @book = book
    book.rentals << self
    @person = person
    person.rentals << self
  end
  def to_h
    {
      'book' => { 'title' => @book.title, 'author' => @book.author },
      'person_id' => @person.id,
      'date' => @date
    }
  end
end
