# frozen_string_literal: true

# lib/game.rb
require 'pry-byebug'
require_relative 'messages'
require_relative 'display'
require 'msgpack'

# Makes sure the symbols survive serialization/deserialization
MessagePack::DefaultFactory.register_type(0x00, Symbol)

# Handles game input, game logic and holds game state
class Game
  LAST_TURN = 12
  MIN_WORD_LENGTH = 8
  private_constant :LAST_TURN, :MIN_WORD_LENGTH
  extend Messages
  def initialize
    @state = {word_to_guess: random_word,
              letters_uncovered: [],
              guesses_made: [],
              turn: 0
    }

    @state[:letters_uncovered] = Array.new(@state[:word_to_guess].length)

    @display = Display.new
  end

  def save
    save_file = File.open('save', 'wb')
    save_data = @state.to_msgpack
    save_file.write(save_data)
    save_file.close
    @display.show(@state, Messages.save)
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

  def help
    @display.show(@state, Messages.help)
  end

  def random_word
    dictionary_name = 'words.txt'
    dictionary = File.open(dictionary_name)
    line_count = `wc -l '#{dictionary_name}'`.to_i

    cur_line = 0
    random_line = rand(0..line_count)

    until cur_line == random_line
      word = dictionary.readline.chomp
      cur_line += 1
    end

    dictionary.close
    if word.length < MIN_WORD_LENGTH
      word = random_word
    end
    word
  end

  def make_guess
    # Examples: from 'a\n' to 'Z\n'.
    acceptable = /(?<!.)[a-zA-Z]\n/
    guess = handle_input(acceptable).downcase

    if @state[:guesses_made].any? guess
      @display.show(@state, Messages.same_guess)
      make_guess
    else
      @state[:guesses_made] << guess
      uncover_letters(guess)
    end
  end

  def special_input(input)
    case input
    when "q!\n"
      exit
    when "s!\n"
      save
    when "l!\n"
      load
    when "h!\n"
      help
    when "r!\n"
      replay
    end
  end

  def handle_input(acceptable_pattern)
    input = gets
    special_input(input)
    choice = input.scan(acceptable_pattern)
    if choice.length.zero?
      @display.show(@state, Messages.bad_input)
      special_input(input)
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
    @display.show(@state, Messages.intro)

    until @state[:turn] == LAST_TURN || victory?
      make_guess
      @state[:turn]+= 1
      @display.show(@state, Messages.play)
    end

    if victory?
      @display.show(@state, Messages.victory)
    else
      @display.show(@state, Messages.loss)
    end

    if gets == "r!\n"
      replay
    end

  end

    def replay
      @state[:word_to_guess] = random_word
      @state[:letters_uncovered] = Array.new(@state[:word_to_guess].length)
      @state[:guesses_made] = []
      @state[:turn] = 0
      play
    end

end

Game.new.play
