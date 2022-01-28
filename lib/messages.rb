# frozen_string_literal: true

# lib/input_helper.rb
# Holds relevant messages to send depending on the situation
module Messages
  def self.bad_input
    puts 'Seems like your input was invalid. Try again, enter q! to quit or s! to save.'
  end

  def self.save
    puts 'Your data was saved! You can continue guessing or quit the game.'
  end

  def self.load
    puts 'Your data was loaded!'
  end

  def self.no_file
    puts 'Save file does not exist.'
  end
end
