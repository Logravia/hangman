# lib/game.rb
require 'pry-byebug'
require_relative 'input'

class Game
  extend Input
  def initialize
    @word_to_guess = random_word
    @letters_uncovered = Array.new(@word_to_guess.length)
    @guesses_made = []
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
  def guess
    puts "Guess a letter: "
    # Examples: from 'a\n' to 'Z\n'.
    acceptable = /(?<!.)[a-zA-Z]\n/
    guess = Input.choose(acceptable).downcase

    if @guesses_made.any? guess
      puts "You already made that guess"
      guess
    else
      @guesses_made << guess
    end
  end
end

at_exit do
  puts "Games was saved before exit!"
end

