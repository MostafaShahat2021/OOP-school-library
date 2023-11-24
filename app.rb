require 'json'
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
    # puts @books.inspect
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
    # @books << Book.new(title, author)
    book = Book.new(title, author)
    @books << book
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

  def load_data_from_json
    load_books_from_json
    load_people_from_json
    load_rentals_from_json
  end

  def load_books_from_json
    books_data = begin
      JSON.parse(File.read('books.json'))
    rescue StandardError
      []
    end
    @books = books_data.map { |data| create_book_from_data(data) }
  end

  def create_book_from_data(data)
    Book.new(data['title'], data['author'])
  end

  def load_people_from_json
    people_data = JSON.parse(File.read('people.json')) rescue []
    loaded_people = people_data.map { |data| create_person_from_data(data) }
  
    # Use a hash to store mapping between old and new IDs
    id_mapping = {}
  
    loaded_people.each do |loaded_person|
      existing_person = @peoples.find { |p| p.name == loaded_person.name }
      if existing_person
        # Assign the existing ID to the loaded person
        loaded_person.id = existing_person.id
      else
        # Use the loaded ID or generate a new one
        loaded_person.id ||= Random.rand(1..1000)
      end
  
      # Store the mapping
      id_mapping[loaded_person.id] ||= loaded_person.id
    end
  
    # Update the IDs of the loaded rentals to use the new IDs
    loaded_people.each do |loaded_person|
      loaded_person.rentals.each do |rental|
        rental.person.id = id_mapping[rental.person.id] || rental.person.id
      end
    end
  
    @peoples += loaded_people
  end

  def create_person_from_data(data)
    case data['type']
    when 'Teacher' then Teacher.new(data['age'], data['specialization'], name: data['name'],
                                                                         parent_permission: data['parent_permission'])
    when 'Student' then Student.new(data['age'], name: data['name'], parent_permission: data['parent_permission'])
    else raise "Invalid person type: #{data['type']}"
    end
  end

  def load_rentals_from_json
    begin
      rentals_data = JSON.parse(File.read('rentals.json')) rescue []
      rentals_data.each_with_index do |data, index|
        begin
          create_rental_from_data(data)
        rescue StandardError => e
          puts "Error loading rental at index #{index}: #{e.message}"
          puts "Data at index #{index}: #{data.inspect}"
        end
      end
    rescue StandardError => e
      puts "Error loading rentals: #{e.message}"
    end
  end

  def create_rental_from_data(data)
    book_index = data['book_index'].to_i
  
    # Ensure the book index is valid
    if book_index >= 0 && book_index < @books.length
      book = @books[book_index]
      person_id = data['person_id']
      person = @peoples.find { |people| people.id == person_id }
  
      if book && person
        Rental.new(book, person, data['date'])
      else
        puts "Error creating rental: Book or person not found. Data: #{data.inspect}"
        nil
      end
    else
      puts "Error creating rental: Invalid book index. Data: #{data.inspect}"
      nil
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
    books_data = @books.map { |book| { 'title' => book.title, 'author' => book.author } }
    File.write('books.json', JSON.generate(books_data))
  end

  def save_people_to_json
    File.write('people.json', JSON.generate(@peoples.map(&:to_h)))
  end

  def save_rentals_to_json
    File.write('rentals.json', JSON.generate(getrentals_data))
  end

  def getrentals_data
    @peoples.flat_map { |people| people.rentals.map(&:to_h) }
  end
end
