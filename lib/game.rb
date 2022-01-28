# lib/game.rb
require 'pry-byebug'
require_relative 'input'
require_relative 'display'

class Game
  extend Input
  def initialize
    @word_to_guess = random_word.split('')
    @letters_uncovered = Array.new(@word_to_guess.length)
    @guesses_made = []
    @display = Display.new
  end

  def random_word
    dictionary_name = "words.txt"
    dictionary = File.open(dictionary_name)
    line_count = %x{wc -l '#{dictionary_name}'}.to_i

    cur_line = 0
    random_line = rand(0..line_count)

    while cur_line <= random_line
      word = dictionary.readline
      cur_line += 1
    end

    dictionary.close
    word.chomp
  end
  def make_guess
    puts "Guess a letter: "
    # Examples: from 'a\n' to 'Z\n'.
    acceptable = /(?<!.)[a-zA-Z]\n/
    guess = Input.choose(acceptable).downcase

    if @guesses_made.any? guess
      puts "You already made that guess"
      guess
    else
      @guesses_made << guess
      uncover_letters(guess)
    end
  end
  def uncover_letters(guess_letter)
    match_count = 0
    @word_to_guess.each_with_index do |letter, placement|
     if letter == guess_letter
       @letters_uncovered[placement] = letter
       match_count += 1
     end
   end
    match_count
  end
  def play
    @display.show_game(@letters_uncovered, @guesses_made)
    until @letters_uncovered == @word_to_guess
      make_guess
      @display.clear_screen
      @display.show_game(@letters_uncovered, @guesses_made)
    end
  def victory
    "You got it! Well done!"
  end
  end
end

at_exit do
  puts "Games was saved before exit!"
end

Game.new.play
