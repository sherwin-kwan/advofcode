
class Puzzle
  def initialize(file)
    @data = Hash.new
    @shortest = Hash.new(9999)
    @unvisited = Hash.new(true)
    @shortest[0 + 0.i] = 0
    open(file).each_line.map(&:strip).tap{@height = _1.count}.each_with_index {|row, i| row.split("").tap{@width = _1.count}.each_with_index  do |cell, j| 
      @data[i + j.i] = cell.to_i
      # (0..4).each do |offset_x|
      #   (0..4).each do |offset_y|
      #     next if offset_x == 0 && offset_y == 0
      #     @data[i + offset_x * @height + (j + offset_y * @width).i] = (cell.to_i + offset_x + offset_y - 1) % 9 + 1
      #   end
      # end
    end
    }
    # @height = @height * 5
    # @width = @width * 5
  end

  def adjacent(c)
    return [c + 1, c + 1.i, c - 1, c - 1.i].filter{|n| [*0...@height].index(n.real) && [*0...@width].index(n.imaginary)}
  end

  def iterate(coord)
    adjacent(coord).filter{@unvisited[_1]}.each do |point|
      @shortest[point] = [@shortest[point], @shortest[coord] + @data[point]].min
    end
  end

  def solve
    destination = @height - 1 + (@width - 1).i
    counter = 0
    stamp = Time.now
    loop do
      min_point = @shortest.sort{|a, b| a.last <=> b.last}.map{|k, v| k}.first
      break if min_point == destination || !min_point
      iterate(min_point)
      @unvisited[min_point] = false
      @shortest.delete(min_point)
      counter += 1
      if counter % 100 == 0
        p [counter, Time.now - stamp
        stamp = Time.now
      end
    end
    p @shortest[destination], counter
  end
end

stamp = Time.now
p = Puzzle.new("./15.txt")
p.solve
puts Time.now - stamp