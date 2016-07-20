
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
end