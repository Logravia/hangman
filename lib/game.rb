# lib/game.rb
require 'pry-byebug'

class Game
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
end
