# frozen_string_literal: true

# lib/display.rb
class Display
  def show_game(letters_uncovered, guesses_made)
    print 'Guesses you made: '
    print_arr(guesses_made)
    print 'Current result: '
    print_arr(letters_uncovered)
    puts "\n\n\n"
  end

  def print_arr(arr)
    arr.each do |element|
      if element.nil?
        print '_ '
      else
        print "#{element} "
      end
    end
    puts ''
  end

  def clear_screen
    puts "\e[H\e[2J"
  end
end
