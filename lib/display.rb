# frozen_string_literal: true

# lib/display.rb
class Display
  def show(state, message)
    clear_screen
    stripe
    turns_left(state)
    print 'Guesses made: '
    print_arr(state[:guesses_made])
    print 'Letters uncovered: '
    print_arr(state[:letters_uncovered])
    stripe
    padding
    print message
    padding
    padding
    prompt
  end

  def padding
    puts "\n\n"
  end

  def stripe
    puts '+---------------+---------------+---------------+'
  end

  def prompt
    print '> '
  end

  def turns_left(state)
    print 'Turns left: '
    state[:turn].times do
      print '[X]'
    end
    (12 - state[:turn]).times do
      print '[ ]'
    end
    puts ''
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
