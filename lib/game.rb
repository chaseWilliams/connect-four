require './array_extension'
require 'matrix'
### var player can ONLY be 1 or 2, as in player1 or player2

class Game
  attr_reader :pieces, :piece_count, :SIZE
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
    check = false
    (1..2).each do |player|
      check = true if horizontal_check player
      check = true if vertical_check player
      check = true if diagonal_check player
    end
    check
  end

  private

  def horizontal_check player
    @pieces.each do |row|
      (0..@SIZE - 4).each do |index|
        temp_arr = row.slice index, index + 4
        if checker_helper temp_arr, player
          puts 'horizontal'
          return true
        end
      end
    end
    false
  end

  def vertical_check player
    (0 .. @SIZE - 1).each do |col|
      if @piece_count[col] >= 4
        temp_arr = []
        @pieces.each do |row_arr|
          temp_arr << row_arr[col]
        end
        #iterate over temp_arr, make into four elements
        (0 .. @SIZE - 4).each do |index|
          final_arr = temp_arr.slice index, index + 4
          if checker_helper final_arr, player
            puts 'vertical'
            return true
          end
        end
      end
    end
    false
  end

  def diagonal_check player

  end

  # takes a four-element arr and checks for consistency
  def checker_helper row, player
    if row.length == 0
      true
    elsif row[0] == player
      row.slice! 0
      checker_helper row, player
    else
      false
    end
  end
end

board = Game.new(6)

board.add_piece 3, 2
board.add_piece 3, 2
board.add_piece 3, 2
board.add_piece 3, 2
board.add_piece 0, 2
board.add_piece 0, 2
board.add_piece 5, 1
board.add_piece 4, 5
print board.pieces.board_print
print board.pieces.diagonalize.board_print
