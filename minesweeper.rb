class Minesweeper

  def initialize
    @board = Board.new
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
    else
      '?'
      # fringe_squares #return number or string?
    end
  end

end

class Board

  attr_accessor :board

  def initialize(dimension = 9)
    @board = Array.new(dimension) {Array.new(dimension) {Tile.make_tile}}
  end

  def display
    puts "  #{(0..(board.count - 1)).to_a.join(' ')}"
    board.each_with_index do |row, row_i|
      puts "#{row_i.to_s} #{row.map{ |tile| tile.display }.join(' ')}"
    end
  end

end

b = Board.new
b.display