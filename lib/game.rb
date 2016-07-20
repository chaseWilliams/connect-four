require './array_extension'

### var player can ONLY be 1 or 2, as in player1 or player2

class Game
  attr_reader :pieces
  def initialize boardSize
    @SIZE = boardSize
    #create a square 2-D array of @SIZE length, filled with 0's
    @pieces = Array.new(@SIZE) {Array.new(@SIZE, 0)}

    @piece_count = Array.new(@SIZE, 0)
  end

  def add_piece col, player
    unless @piece_count[col] == @SIZE
      row = @SIZE - @piece_count[col] - 1
      @pieces[row][col] = player
      @piece_count[col] += 1
    end
  end

  def check_for_victory
    horizontal_check
    #vertical_check
    #diagonal_check
  end

  private

  def horizontal_check
    (1..2).each do |player|
      @pieces.each do |row|
        (0..@SIZE - 4).each do |index|
          temp_row = row.slice index, index + 4
          if horizontal_helper temp_row, player then return true end
        end
      end
    end
    false
  end

  # takes a four-element row arr and checks for consistency
  def horizontal_helper row, player
    if row.length == 0
      puts "found to be true (horizontal)!"
      true
    elsif row[0] == player
      row.slice! 0
      horizontal_helper row, player
    else
      puts "not true :("
      false
    end
  end
end

board = Game.new(5)

board.add_piece 0, 2
board.add_piece 1, 2
board.add_piece 2, 2
board.add_piece 3, 2

print board.pieces.board_print
puts board.check_for_victory