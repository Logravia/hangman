# frozen_string_literal: true

# lib/game.rb
require 'pry-byebug'
require_relative 'messages'
require_relative 'display'
require 'msgpack'

# Handles game input, game logic and holds game state
class Game
  extend Messages
  def initialize
    @word_to_guess = random_word
    @letters_uncovered = Array.new(@word_to_guess.length)
    @guesses_made = []
    @display = Display.new
  end

  def save
    save_file = File.open('save', 'wb')
    save_data = { word_to_guess: @word_to_guess,
                  letters_uncovered: @letters_uncovered,
                  guesses_made: @guesses_made }.to_msgpack
    save_file.write(save_data)
    save_file.close
    Messages.save
  end

  def load
    if File.exist? 'save'
      save_data = MessagePack.unpack(File.read('save'))

      @word_to_guess = save_data['word_to_guess']
      @letters_uncovered = save_data['letters_uncovered']
      @guesses_made = save_data['guesses_made']

      @display.clear_screen
      @display.show_game(@letters_uncovered, @guesses_made)
    else
      Messages.no_file
    end
  end

  def random_word
    dictionary_name = 'words.txt'
    dictionary = File.open(dictionary_name)
    line_count = `wc -l '#{dictionary_name}'`.to_i

    cur_line = 0
    random_line = rand(0..line_count)

    until cur_line == random_line
      word = dictionary.readline
      cur_line += 1
    end

    dictionary.close
    word.chomp.split('')
  end

  def make_guess
    puts 'Guess a letter: '
    # Examples: from 'a\n' to 'Z\n'.
    acceptable = /(?<!.)[a-zA-Z]\n/
    guess = handle_input(acceptable).downcase

    if @guesses_made.any? guess
      puts 'You already made that guess'
      guess
    else
      @guesses_made << guess
      uncover_letters(guess)
    end
  end

  def handle_special_cases(input, acceptable_pattern)
    case input
    when "q!\n"
      exit
    when "s!\n"
      save
      handle_input(acceptable_pattern)
    when "l!\n"
      load
      handle_input(acceptable_pattern)
    end
  end

  def handle_input(acceptable_pattern)
    print '> '
    input = gets
    handle_special_cases(input, acceptable_pattern)
    choice = input.scan(acceptable_pattern)
    if choice.length.zero?
      Messages.bad_input
      choice = handle_input(acceptable_pattern)
    end
    (choice.is_a? String) ? choice : choice.join('').chomp
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
  end
end

Game.new.play
