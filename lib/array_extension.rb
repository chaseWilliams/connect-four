
class Array
  def board_print
    string = ''
    each do |arr|
      string += "|"
      arr.each do |item|
        string += " #{item} "
      end
      string += "|\n"
    end
    string + ' - ' * self.length + "\n"
  end

  ## returns a 2D array that represents ALL of the diagonals in the given array
  ## format is as follows:
  ## the method starts from the top left corner and ends at the bottom right corner
  ## each row is its own diagonal, with the first value being the leftmost original value
  ## and the last value being the rightmost original value
  ##
  ## in order to appease a returned rectangular 2D array, shorter diagonals, when converted to rows,
  ## use nil as filler.
  ##
  ## floor is an optional param that only returns diagonal that are at least the given length
  def diagonalize floor = 0
    raise 'err: not 2d' unless self[0].class == Array
    size = self.length * 2 - 1
    array = Array.new(size) {Array.new}
    # acquire top and main diagonal
    self.length.times do |row|
      (0 .. row).each do |col|
        array[row] << self[row-col][col]
      end
    end
    # now cover the additional bottom diagonals
    (1 .. self.length - 1).reverse_each do |row|
      offset_value = 0
      temp_arr = []
      while row + offset_value < self.length
        temp_arr << self[self.length - 1 - offset_value][row + offset_value]
        offset_value += 1
      end
      array[self.length - 1 + row] = temp_arr
    end
    # phew... now to trim and format
    
    array
  end
end
