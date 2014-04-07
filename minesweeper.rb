class Minesweeper

  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def play
    until board.game_over?
      board.display
      puts "Make your move"
      move = gets.chomp.split(',')
      tile_status = board.take_turn(move)
      board.check_move(tile_status)
    end

    puts "Game over"
    board.display
  end

end

class Tile

  attr_accessor :flagged, :revealed, :bombed

  def initialize(bombed = false)
    @flagged = false
    @revealed = false
    @bombed = bombed
  end

  def self.make_tile
    choice = rand(2)
    choice == 0 ? Tile.new : Tile.new(true)
  end

  def display
    if flagged
      'F'
    elsif !revealed
      '*'
    elsif bombed
      'B'
    else
      '_'
      # fringe_squares #return number or string?
    end
  end

end

class Board

  attr_accessor :tiles

  def initialize(dimension = 9)
    @tiles = Array.new(dimension) {Array.new(dimension) {Tile.make_tile}}
  end

  def display
    puts "  #{(0..(tiles.count - 1)).to_a.join(' ')}"
    tiles.each_with_index do |row, row_i|
      puts "#{row_i.to_s} #{row.map{ |tile| tile.display }.join(' ')}"
    end
  end

  def take_turn(move)
    action, x, y = move[0], move[1].to_i, move[2].to_i
    tile = tiles[x][y]

    if action == 'r'
      tile.revealed = true # also need to check neighbors
    else
      tile.flagged = true
    end

    [x,y]
  end

  def check_move(pos)
    x,y = pos[0],pos[1]
    tile = tiles[x][y]
    unless tile.flagged
      if tile.bombed
        @loser = true
      else
        #check neighbors
      end
    end
  end

  def game_over?
    @winner || @loser
  end

end

g = Minesweeper.new
g.play