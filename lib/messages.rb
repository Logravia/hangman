# frozen_string_literal: true

# lib/input_helper.rb
# Holds relevant messages to send depending on the situation
module Messages
  def self.bad_input
    'Seems like your input was invalid. Try again, enter q! to quit or s! to save.'
  end

  def self.save
    'Your data was saved! You can continue guessing or quit the game.'
  end

  def self.load
    'Your data was loaded!'
  end

  def self.no_file
    'Save file does not exist.'
  end

  def self.play
    'Time to make a guess'
  end
end
