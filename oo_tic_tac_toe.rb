# 2 players decide to play, draw a board. choose who is 'x' and 'o'. 'x' goes
# first and chooses a square. Players alternate until one has 3 in a row.
# Whoever gets 3 in a row first is the winner.

class Player

end

class Human < Player
  attr_reader :name

  def initialize
    puts "Enter name:"
    @name = gets.chomp
  end
end

class Computer < Player
  attr_reader :name

  def initialize
    challengers = ["Johnny Five", "Baymax", "Holly"]
    @name = challengers.sample
  end
end

class Board

  def draw_board

  end

end



class Session

  def initialize
    human = Human.new
    computer = Computer.new
    puts "Your challenger is #{computer.name}"
  end

  def one_game
    board = board.new
  end
end

Session.new
