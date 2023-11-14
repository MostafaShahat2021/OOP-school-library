require_relative 'decorator'

class TrimmerDecorator
  def initialize(nameable)
    # super(nameable)
    @nameable = nameable
  end

  def correct_name
    @nameable.correct_name.length > 10 ? @nameable.correct_name[0...10] : @nameable.correct_name
  end
end