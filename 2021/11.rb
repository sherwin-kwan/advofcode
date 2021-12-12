class DumboOctopus
  def initialize(file)
    @matrix = Hash.new(0)
    @flash_count = 0
    @step_count = 0
    # Save data into a matrix - use a Hash with real/imaginary keys for the 2 dimensions
    open(file).each_line.map(&:strip).tap{@rows = _1.count}.each_with_index {|row, i| row.split("").tap{@cols = _1.count}.each_with_index {|cell, j| @matrix[i + j.i] = cell.to_i}}
  end

  def adjacent(c)
    return [c - 1, c + 1, c + 1.i, c - 1.i, c + 1 + 1.i, c + 1 - 1.i, c - 1 + 1.i, c - 1 - 1.i].filter{|n| [*0...@rows].index(n.real) && [*0...@cols].index(n.imaginary)}
  end

  def step
    @matrix.transform_values!{|v| v + 1}
    flashed = []
    loop do
      flashing = []
      @matrix.each{|k, v| flashing << k if v >= 10 && !flashed.include?(k)}
      break if flashing.empty?
      flashing.each{|k| adjacent(k).each{|adj| @matrix[adj] += 1}}
      flashed.concat(flashing)
    end
    @matrix.transform_values!{|v| v >= 10 ? 0 : v}
    @flash_count += flashed.count
    @step_count += 1
    if @step_count == 100
      puts "Part 1: #{@flash_count}"
    elsif flashed.count == 100
      puts "Part 2: #{@step_count}"
      return true
    end
  end
end

o = DumboOctopus.new("./11.txt")
loop {break if o.step}