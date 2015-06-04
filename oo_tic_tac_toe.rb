# 2 players decide to play, draw a board. choose who is 'x' and 'o'. 'x' goes
# first and chooses a square. Players alternate until one has 3 in a row.
# Whoever gets 3 in a row first is the winner.
require 'Pry'


class Player

  def mark_board(board, choice, symbol)
    board.squares.each_value do |square|
      square.mark = symbol  if square.position == choice
    end
  end

end

class Human < Player
  attr_reader :name

  def initialize
    puts "What is your name:"
    @name = gets.chomp
  end

  def take_turn(board)
    puts 'Your turn, what position 1 - 9 would you like to go?'
    choice = gets.chomp.to_i
    until board.get_empty_squares.include?(choice)
      puts 'Place taken, choose a free space?'
      choice = gets.chomp.to_i
    end

    mark_board(board, choice, 'X')
    board.draw_board
  end

end

class Computer < Player
  attr_reader :name

  def initialize
    opponents = ["Johnny Five", "Baymax", "Holly"]
    @name = opponents.sample
  end

  def take_turn(board)
    choice = board.get_empty_squares.sample
    mark_board(board, choice, 'O')
    board.draw_board
  end

end

class Square
  attr_accessor :mark, :position

  def initialize(position)
    @position = position
    @mark = ' '
  end

  def empty?
    mark == ' '
  end

end

class Board
  attr_accessor :squares

  def initialize
    @squares = {}
    [:s1, :s2, :s3, :s4, :s5, :s6, :s7, :s8, :s9].each_with_index do |key, index|
      @squares[key] = Square.new(index + 1)
    end
  end

  def draw_board
    system 'clear'
    puts " #{squares[:s1].mark} | #{squares[:s2].mark} | #{squares[:s3].mark}"\
         "          1 | 2 | 3 "
    puts '---|---|---        ---|---|---'
    puts " #{squares[:s4].mark} | #{squares[:s5].mark} | #{squares[:s6].mark}"\
         "          4 | 5 | 6 "
    puts '---|---|---        ---|---|---'
    puts " #{squares[:s7].mark} | #{squares[:s8].mark} | #{squares[:s9].mark}"\
         "          7 | 8 | 9 \n "
  end

  def get_empty_squares
    squares.reject { |k,v| v.mark != ' ' }.collect { |k,v| v.position}
  end

  def get_computer_squares
    squares.reject { |k,v| v.mark != 'O' }.collect { |k,v| v.position}
  end

  def get_human_squares
    squares.reject { |k,v| v.mark != 'X' }.collect { |k,v| v.position}
  end

end

class Game
  attr_accessor :game_status

  WINNING_COMBOS = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7],
    [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

  def initialize
    @game_status = 'undecided'
  end

  def update_game_status(board)
    WINNING_COMBOS.each do |combo|
      if (combo - board.get_computer_squares).empty?
        self.game_status = 'computer_won'
      elsif (combo - board.get_human_squares).empty?
        self.game_status = 'human_won'
      end
    end
  end

  def play
    human = Human.new
    loop do
      self.game_status = 'undecided'
      computer = Computer.new
      puts "Your opponent is #{computer.name}"
      sleep(2)
      board = Board.new
      board.draw_board

      while game_status == 'undecided' && !board.get_empty_squares.empty? do
        human.take_turn(board)
        update_game_status(board)
        break if game_status != 'undecided'
        computer.take_turn(board)
        update_game_status(board)
      end

      if game_status == 'human_won'
        puts 'you win!'
      elsif game_status == 'computer_won'
        puts 'computer wins!'
      else
        puts 'its a draw!'
      end

      puts 'Try again? (y/n)'
      break if gets.chomp.downcase == 'n'
    end
  end

end


Game.new.play
