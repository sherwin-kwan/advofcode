class BasinPuzzle
  def initialize(file)
    @data = open(file).each_line.map{_1.strip.split("").map(&:to_i)}
    @w = @data[0].length
    @h = @data.count
    @basins = Array.new(@h){Array.new(@w)} # Saves which basin # a given point (r, c) is part of
  end

  def adjacent(r, c)
    arr = []
    arr << [r - 1, c] unless r == 0
    arr << [r, c - 1] unless c == 0
    arr << [r + 1, c] unless r == @h - 1
    arr << [r, c + 1] unless c == @w - 1
    arr
  end

  def flood_fill(r, c, basin_num)
    adjacent(r, c).filter{|x, y| !@basins[x][y] && @data[x][y] != 9}.each do |x, y|
      @basins[x][y] = basin_num
      flood_fill(x, y, basin_num)
    end
  end

  def solve
    acc = 0
    basin_count = 0
    (0...@h).each do |r|
      (0...@w).each do |c|
        # Part 1 stuff
        num = @data[r][c]
        acc += (num + 1) if adjacent(r, c).map{|x, y| @data[x][y]}.min > num
        # Part 2 stuff
        next if num == 9 || @basins[r][c] # No basin here, or it's part of an existing one!
        basin_count += 1
        @basins[r][c] = basin_count
        flood_fill(r, c, basin_count)
      end
    end
    puts "Part 1: #{acc}"
    puts "Part 2: #{@basins.flatten.compact.tally.map{|k, v| v}.sort.last(3).reduce(&:*)}" 
  end
end

b = BasinPuzzle.new("./09.txt")
b.solve