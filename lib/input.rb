# lib/input_helper.rb

module Input
  def self.bad_input_msg
    puts 'Seems like your input was invalid. Try again or enter q! to quit.'
  end
  def self.choose(acceptable_pattern)
    print '> '
    input = gets
    exit if input == "q!\n"
    choice = input.scan(acceptable_pattern)
    if choice.length.zero?
      bad_input_msg
      choice = choose(acceptable_pattern)
    end
    choice.join.chomp
  end
end
