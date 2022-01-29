# frozen_string_literal: true

# lib/input_helper.rb
# Holds relevant messages to send depending on the situation
module Messages
  def self.bad_input
    "Seems like your input was invalid.\nEnter h! for help or continue guessing."
  end

  def self.save
    'Your data was saved!'
  end

  def self.load
    'Your data was loaded!'
  end

  def self.no_file
    'Save file does not exist.'
  end

  def self.play
    'Time to make another guess ...'
  end

  def self.same_guess
    'You already made that guess.'
  end

  def self.guess
    'Take a guess ... '
  end

  def self.intro
    "The computer has chosen a random word.\nCan you guess it in 12 turns or less?\nTake a guess ..."
  end

  def self.help
    "To quit enter: q!\nTo save the game enter: s!\nTo load previous session: l!\nTo continue the game enter a guess ..."
  end
end
