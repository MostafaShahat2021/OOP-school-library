require_relative 'teacher'
require_relative 'student'
require_relative 'book'
require_relative 'rental'

class App
  def initialize
    @books = []
    @peoples = []
  end

  def list_all_books
    @books.each { |book| puts "Name:- #{book.title} Author:- #{book.author} \n" }
  end

  def list_all_peoples
    @peoples.each do |people|
      puts "[#{people.class.name}] Name:- #{people.name} ID:- #{people.id} Age:- #{people.age} \n"
    end
  end

  def create_teacher(age, specialization, name, parent_permission)
    @peoples << Teacher.new(age, specialization, name: name, parent_permission: parent_permission)
  end

  def create_student(age, name, parent_permission)
    @peoples << Student.new(age, name: name, parent_permission: parent_permission)
  end

  def create_book
    puts 'Title of the book'
    title = gets.chomp
    puts 'Author of the book'
    author = gets.chomp
    @books << Book.new(title, author)
  end

  def create_rental
    puts 'Select a book from the list by number'
    @books.each.with_index { |book, index| puts "#{index} - #{book.title} by #{book.author}" }
    book_index = gets.chomp.to_i
    puts 'Select a person from the list by number'
    @peoples.each.with_index do |people, index|
      puts "#{index} - [#{people.class.name}] Nmae #{people.name} ID #{people.id} Age #{people.age}"
    end
    person_index = gets.chomp.to_i
    puts 'Date: (yyyy-mm-dd)'
    date = gets.chomp
    Rental.new(@books[book_index], @peoples[person_index], date)
  end

  def list_rentals(person_id = nil)
    if person_id
      @peoples.each do |people|
        next unless people.id == person_id

        puts 'Rentals:'
        people.rentals.each do |rental|
          puts "Date #{rental.date}, Book #{rental.book.title} by #{rental.book.author}"
        end
      end
    else
      puts 'Rentals for all people:'
      @peoples.each do |people|
        people.rentals.each do |rental|
          puts "Person ID: #{people.id}, Date #{rental.date}, Book #{rental.book.title} by #{rental.book.author}"
        end
      end
    end
  end

  def exit_app
    save_data_to_json
    puts 'Exiting the application. Goodbye!'
    exit
  end
  
  def save_data_to_json
    save_books_to_json
    save_people_to_json
    save_rentals_to_json
  end
  
  def save_books_to_json
    books_data = @books.map { |book| { "title" => book.title, "author" => book.author } }
    File.open('books.json', 'w') { |file| file.write(JSON.generate(books_data)) }
  end  
  
  def save_people_to_json
    File.open('people.json', 'w') { |file| file.write(JSON.generate(@peoples.map(&:to_h))) }
  end
  
  def save_rentals_to_json
    File.open('rentals.json', 'w') { |file| file.write(JSON.generate(get_rentals_data)) }
  end
  
  def get_rentals_data
    @peoples.flat_map { |people| people.rentals.map(&:to_h) }
  end
end
