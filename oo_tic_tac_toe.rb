# oo_tic_tac_toe.rb

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
    puts 'What is your name:'
    @name = gets.chomp
  end

  def take_turn(board)
    puts 'Your turn, what position 1 - 9 would you like to go?'
    choice = gets.chomp.to_i
    until board.empty_square?(choice)
      puts "Sorry, you can't go there! Please choose a free position."
      choice = gets.chomp.to_i
    end

    mark_board(board, choice, 'X')
    board.draw_board
  end

end

class Computer < Player
  attr_reader :name

  def initialize
    opponents = ['Johnny Five', 'Baymax', 'Holly']
    @name = opponents.sample
  end

  def take_turn(board)
    if win(board) != false
      choice = win(board)
    elsif defend(board) != false
      choice = defend(board)
    else
      choice = board.empty_squares.sample
    end

    mark_board(board, choice, 'O')
    sleep(1)
    board.draw_board
  end

  def win(board)
    Board::WINNING_COMBOS.each do |combo|
      amount_occupied_by_computer = (board.computer_squares & combo).count
      amount_empty = (board.empty_squares & combo).count
      if amount_occupied_by_computer == 2 && amount_empty == 1
        return (combo - board.computer_squares)[0]
      end
    end
    false
  end

  def defend(board)
    Board::WINNING_COMBOS.each do |combo|
      amount_occupied_by_human = (board.human_squares & combo).count
      amount_empty = (board.empty_squares & combo).count
      if amount_occupied_by_human == 2 && amount_empty == 1
        return (combo - board.human_squares)[0]
      end
    end
    false
  end

end

class Square
  attr_accessor :mark, :position

  def initialize(position)
    @position = position
    @mark = ' '
  end

end

class Board
  attr_accessor :squares

  WINNING_COMBOS = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7],
    [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    [:s1, :s2, :s3, :s4, :s5, :s6, :s7, :s8, :s9].each_with_index do |k, i|
      @squares[k] = Square.new(i + 1)
    end
  end

  def draw_board
    system 'clear'
    puts " #{squares[:s1].mark} | #{squares[:s2].mark} | #{squares[:s3].mark}"\
         '          1 | 2 | 3 '
    puts '---|---|---        ---|---|---'
    puts " #{squares[:s4].mark} | #{squares[:s5].mark} | #{squares[:s6].mark}"\
         '          4 | 5 | 6 '
    puts '---|---|---        ---|---|---'
    puts " #{squares[:s7].mark} | #{squares[:s8].mark} | #{squares[:s9].mark}"\
         "          7 | 8 | 9 \n "
  end

  def square_array(mark)
    squares.reject { |_, v| v.mark != mark }.collect { |_, v| v.position }
  end

  def computer_squares
    square_array('O')
  end

  def human_squares
    square_array('X')
  end

  def empty_squares
    square_array(' ')
  end

  def empty_square?(position)
    empty_squares.include?(position)
  end

end

class Game

  def initialize
    @human = Human.new
    @computer = Computer.new
    @current_player = @human
  end

  def change_player
    if @current_player == @human
      @current_player = @computer
    else
      @current_player = @human
    end
  end

  def human_win?(board)
    outcome = false
    Board::WINNING_COMBOS.each do |combo|
      outcome = true if (combo - board.human_squares).empty?
    end
    outcome
  end

  def computer_win?(board)
    outcome = false
    Board::WINNING_COMBOS.each do |combo|
      outcome = true if (combo - board.computer_squares).empty?
    end
    outcome
  end

  def play
    loop do
      puts "Your opponent is #{@computer.name}"
      sleep(2)
      board = Board.new
      board.draw_board

      while !board.empty_squares.empty? &&
            !human_win?(board) && !computer_win?(board)
        if @current_player == @human
          @human.take_turn(board)
        else
          @computer.take_turn(board)
        end
        change_player
      end

      if human_win?(board)
        puts "You win!"
      elsif computer_win?(board)
        puts "#{@computer.name} wins!"
      else
        puts "It's a draw!"
      end

      puts 'Try again? (y/n)'
      break if gets.chomp.downcase == 'n'
      @computer = Computer.new
    end
  end
end

Game.new.play
