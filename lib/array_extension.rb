
class Array
  def board_print
    string = ''
    each do |arr|
      string += "|"
      arr.each do |item|
        unless item.nil?
          string += " #{item} "
        else
          string += ' * '
        end
      end
      string += "|\n"
    end
    string + ' - ' * self.length + "\n"
  end

  ## returns a matrix that represents ALL of the diagonals in the given array
  ## format is as follows:
  ## the method starts from the top left corner and ends at the bottom right corner
  ## each row is its own diagonal, with the first value being the leftmost original value
  ## and the last value being the rightmost original value
  ##
  ## in order to appease a returned rectangular matrix, shorter diagonals, when converted to rows,
  ## use nil as filler.
  ##
  ## floor is an optional param that only returns diagonals that are at least the given length
  def diagonalize floor = 0
    raise 'err: not 2d' unless self[0].class == Array
    size = self.length + self[0].length - 1
    array = Array.new(size) {Array.new}
    # acquire top and main diagonal
    self.length.times do |row|
      (0 .. row).each do |col|
        array[row] << self[row-col][col]
      end
    end
    # now cover the additional bottom diagonals
    sides_difference = self.length[0] - self.length
    if sides_difference == 0
      (1 .. self.length - 1).reverse_each do |row|
        offset_value = 0
        temp_arr = []
        while row + offset_value < self.length
          temp_arr << self[self.length - 1 - offset_value][row + offset_value]
          offset_value += 1
        end
        array[self.length - 1 + row] = temp_arr
      end
    else
      (1 .. self[0].length - 1).reverse_each do |row|
        offset_value = 0
        temp_arr = []
        while row + offset_value < self[0].length
          temp_arr << self[self.length - 1 - offset_value][row + offset_value]
          offset_value += 1
        end
        array[self[0].length - 2 + row] = temp_arr
      end
    end

    # phew... now to trim and format
    unless floor == 0
      index = 0
      while index < size
        if array[index].length < floor
          array.slice! index
          size -= 1
          index -= 1
        end
        index += 1
      end
    end

    (0..size-1).each do |index|
      while array[index].length < self.length
        array[index] << nil
      end
    end
    array
  end

  ## flips an arr, from right to left
  def flip
    arr = Array.new(self.length)
    (0..self.length / 2).each do |index|
      arr[index] = self[self.length - 1 - index]
      arr[self.length - 1 - index] = self[index]
    end
    arr
  end

  def matrix_flip
    map {|elem| elem.flip}
  end
end

#arr = [[0, 0, 0, 0, 0, 0], [1, 0, 0, 0, 0, 0], [1, 1, 0, 0, 0, 0], [2, 1, 1, 0, 0, 0], [1, 1, 2, 1, 0, 0]]
#print arr.board_print
#print arr.diagonalize.board_print
