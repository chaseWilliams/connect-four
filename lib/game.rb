
### var player can ONLY be 1 or 2, as in player1 or player2

class Game
  attr_reader :pieces, :piece_count, :SIZE
  def initialize boardSize, pieces = nil, piece_count = nil
    @SIZE = boardSize
    #create a square 2-D array of @SIZE length, filled with 0's
    if pieces.nil? || piece_count.nil?
      @pieces = Array.new(@SIZE) {Array.new(@SIZE + 1, 0)}
      @piece_count = Array.new(@SIZE, 0)
    else
      @pieces = pieces
      @piece_count = piece_count
    end
    @db = Mongo::Client.new 'mongodb://127.0.0.1:27017/test' #default mongod instance
  end

  def add_piece col, player
    unless @piece_count[col] == @SIZE
      row = @SIZE - @piece_count[col] - 1
      @pieces[row][col] = player
      @piece_count[col] += 1
    end
  end

  def check_for_victory
    result = begin_check
    if result[:win]
      history = @db[:history]
      history.insert_one self.dump
    end
    result
  end

  ## Game#dump and Game#load are for serializing and reconstituting the object,
  ## as to add translation to JSON
  def dump
    {
        pieces: @pieces,
        piece_count: @piece_count,
        size: @SIZE
    }
  end

  def self.load hash
    self.new(hash['size'], hash['pieces'], hash['piece_count'])
  end

  private

  def begin_check
    print @pieces.board_print
    (1..2).each do |player|
      return {win: true, player: player} if horizontal_check player
      return {win: true, player: player} if vertical_check player
      return {win: true, player: player} if diagonal_check player
    end
    {win: false, player: nil}
  end

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
    diagonals = @pieces.diagonalize 4
    return true if diagonal_helper diagonals, player
    reverse_diagonals = @pieces.matrix_flip.diagonalize 4
    return true if diagonal_helper reverse_diagonals, player
    false
  end

  def diagonal_helper arr, player
    arr.each do |sub_arr|
      (0..sub_arr.length - 4).each do |index|
        temp_arr = sub_arr.slice index, index + 4
        if temp_arr.length == temp_arr.compact.length
          if checker_helper temp_arr, player
            puts 'diagonal'
            return true
          end
        end
      end
    end
    false
  end

  # takes a four-element arr and checks for consistency
  def checker_helper arr, player
    if arr.length == 0
      true
    elsif arr[0] == player
      arr.slice! 0
      checker_helper arr, player
    else
      false
    end
  end
end
