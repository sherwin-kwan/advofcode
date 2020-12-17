class Exercise3

  # Begin by reading the file and turning its contents into a 2D array.
  # [[.#..],[#...],[##..]] etc.
  # In this case, we will define the y-axis going downwards (south) and the x-axis going to the right (east) -
  # For any coordinate (x, y), there is a tree if, in within row y, at position x mod (width of repeating pattern), there is a character #
  # Iterate from 0 to (height of repeating pattern) and find whether (3x, y) has a tree. Increment counter when a tree is found.
  # Return counter

  data = open("03-input.txt").read.split("\n");  # Array of rows
  the_terrain = data.map do |row|
    row.split("")
  end

  # Check that lengths are the same for each row
  # the_terrain.each do |row|
  #   puts row.length;
  # end

  # Is (x, y) a tree?
  def self.tree?(x, y, terrain)
    height = terrain.length
    width = terrain[0].length
    # No trees when y is above or below the forest
    if y >= height || y < 0
      return false
    end
    if terrain[y][x % width] == "#"
      return true
    elsif terrain[y][x % width] == "."
      return false
    else
      raise "Unknown character identified"
    end
  end

  # "3 right, 1 down" is the original example
  def self.count_trees(right, down, terrain)
    counter = 0
    # Need to add 1 because integer division rounds down. If you go down 10 rows at a time, you'll have to iterate from 0 to 32, inclusive,
    # but 323/10 evaluates to 32
    (0...terrain.length / down + 1).each do |num|
      if tree?(num * right, num * down, terrain)
        counter += 1
      end
    end
    puts "#{counter} trees encountered."
    counter
  end

  count_trees(3, 1, the_terrain)
  # Output: 173 trees encountered.

  parameters = [
    { right: 1, down: 1 },
    { right: 3, down: 1 },
    { right: 5, down: 1 },
    { right: 7, down: 1 },
    { right: 1, down: 2 },
  ]

  def self.find_product(params, terrain)
    trees_encountered_array = params.map do |param|
      count_trees(param[:right], param[:down], terrain)
    end
    puts "Trees encountered are: "
    p trees_encountered_array
    puts "Product is #{trees_encountered_array.reduce(:*)}"
  end

  find_product(parameters, the_terrain)
  # Output: Trees encountered are:
  # [82, 173, 84, 80, 46]
  # Product is 4385176320

  ########33
  # trees = 0
  # count = 0

  # the_terrain.each do |arr|
  #   arr.each do |char|
  #     count += 1
  #     if char === '#'
  #       trees += 1
  #     end
  #   end
  # end

  # puts "#{trees} trees in #{count} positions"

end
