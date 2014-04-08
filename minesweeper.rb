require 'debugger'
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
    end

    puts "Game over"
    board.display
  end

end

class Tile

  NEIGHBOR_TILES =     [
      [-1,-1],[0,-1],[1,-1],
      [-1,0],        [1,0],
      [-1,1], [0,1], [1,1]
    ]


  attr_accessor :flagged, :revealed, :bombed, :value, :position

  def initialize(pos,bombed = false)
    @flagged = false
    @revealed = false
    @bombed = bombed
    @value = '*'
    @position = pos
  end

  def bombed?
    bombed
  end

  def self.make_tile(pos)
    choice = rand(10)
    choice == 0 ? Tile.new(pos,true) : Tile.new(pos)
  end

  def reveal(val)
    self.revealed = true
    self.value = (val == 0 ? '_' : val.to_s)
  end

  def flag
    self.flagged = true
    self.value = 'F'
  end

  def neighbor_positions
    neighbors = []
    x, y = position[0], position[1]
    NEIGHBOR_TILES.each do |pos|
      new_x, new_y = x + pos[0], y + pos[1]
      next if !new_x.between?(0,8) || !new_y.between?(0,8)
      neighbors << [new_x,new_y]
    end
    neighbors
  end
end



class Board

  attr_accessor :tiles

  def initialize(dimension = 9)
    @tiles = Array.new(dimension) {Array.new(dimension)}
    dimension.times do |i|
      dimension.times do |j|
        @tiles[i][j] = Tile.make_tile([i,j])
      end
    end
  end

  def display
    puts "  #{(0..(tiles.count - 1)).to_a.join(' ')}"
    tiles.each_with_index do |row, row_i|
      puts "#{row_i.to_s} #{row.map{ |tile| tile.value }.join(' ')}"
    end
  end

  def take_turn(move)
    action, x, y = move[0], move[1].to_i, move[2].to_i
    tile = tiles[x][y]

    if action == 'r'
      if tile.bombed?
        @loser = true
        tile.reveal('B')
        reveal_all_tiles
      else
        neighbor_bombs_count = check_neighbor_bombs(tile)
        tile.reveal(neighbor_bombs_count)
        # reveal_neighbors(x,y)  # also need to check neighbors
      end
    else
      tile.flag
    end

    [x,y]
  end

  def neighbors(tile)
    tile.neighbor_positions.map do |pos|
      tiles[pos[0]][pos[1]]
    end
  end

  def check_neighbor_bombs(tile)
    neighbor_bomb_count = 0
    neighbors(tile).each do |neighbor|
      neighbor_bomb_count += 1 if neighbor.bombed?
    end
    neighbor_bomb_count
  end

  def reveal_neighbors(tile)
    visited_tiles = []
    neighbors(tile).each do |neighbor|
      bomb_count = check_neighbor_bombs(neighbor)

      if bomb_count == 0
        neighbor.reveal("_")
        reveal_neighbors(neighbor)
      else
        neighbor.reveal(bomb_count)
      end
    end
  end

  def reveal_all_tiles
    tiles.each do |row|
      row.each do |tile|
        unless tile.revealed
          tile.bombed? ? tile.reveal('B') : tile.reveal('_')
        end
      end
    end
  end

  def game_over?
    @winner || @loser
  end

end

g = Minesweeper.new
g.play