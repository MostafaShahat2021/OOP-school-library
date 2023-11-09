class Person
  attr_reader :id, :name, :age
  attr_writer :name, :age
  def initialize(age, name = 'Unknown', parent_permission = true)
    @id = Random.rand(1..1000)
    @name = name
    @age = age
    @parent_permission = parent_permission
  end

  private
  def  of_age?
    @age >= 18
  end

  def can_use_services?
    of_age? || @parent_permission
  end
end

mostafa = Person.new(18, 'Mostafa', false)
puts mostafa.can_use_services? # => true
mostafa_2 = Person.new(15, 'Mostafa', false)
puts mostafa_2.can_use_services?  # => false