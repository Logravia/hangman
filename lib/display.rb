# frozen_string_literal: true

# lib/display.rb
class Display
  def show(state, message, error='')
    clear_screen
    print 'Guesses you made: '
    print_arr(state[:guesses_made])
    print 'Current result: '
    print_arr(state[:letters_uncovered])
    padding
    print message
    padding
    prompt
  end

  def padding
    puts "\n\n"
  end

  def prompt
    print '> '
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
