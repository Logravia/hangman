# frozen_string_literal: true

# lib/game.rb
require 'pry-byebug'
require_relative 'messages'
require_relative 'display'
require 'msgpack'

MessagePack::DefaultFactory.register_type(0x00, Symbol)

# Handles game input, game logic and holds game state
class Game
  extend Messages
  def initialize
    @state = {word_to_guess: random_word,
              letters_uncovered: [],
              guesses_made: []
    }

    @state[:letters_uncovered] = Array.new(@state[:word_to_guess].length)

    @display = Display.new
  end

  def save
    save_file = File.open('save', 'wb')
    save_data = @state.to_msgpack
    save_file.write(save_data)
    save_file.close
  end

  def load
    if File.exist? 'save'
      save_data = MessagePack.unpack(File.read('save'))
      @state = save_data
      @display.clear_screen
      @display.show(@state, Messages.load)
    else
      @display.show(@state, Messages.no_file)
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
    puts 'Guess a letter ... '
    # Examples: from 'a\n' to 'Z\n'.
    acceptable = /(?<!.)[a-zA-Z]\n/
    guess = handle_input(acceptable).downcase

    if @state[:guesses_made].any? guess
      puts 'You already made that guess'
      guess
    else
      @state[:guesses_made] << guess
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
    @state[:word_to_guess].each_with_index do |letter, placement|
      if letter == guess_letter
        @state[:letters_uncovered][placement] = letter
        match_count += 1
      end
    end
    match_count
  end

  def victory?
    @state[:letters_uncovered] == @state[:word_to_guess]
  end
  def play
    until victory?
      make_guess
      @display.show(@state, Messages.play)
    end
  end
end

Game.new.play
