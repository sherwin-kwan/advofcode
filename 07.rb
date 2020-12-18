# This exercise involves creating a directed graph where the nodes are colours. You want to identify whether a path exists from node A to node B.
# Do cycles exist? Otherwise it's a tree. Well, regardless, the algorithm can be implemented recursively.
#
# STEP 1: PARSE THE FILE
# For each line in the file, extract as follows using splits: <A> bags contain <#> <B>, <#> <C>, ... bags.

# STEP 2: CREATE THE TREE/GRAPH
# Create a master hash, where all the values are arrays. Push "A" to the arrays for keys B, C, and D.
# (Create the array if it hasn't been created yet)
# Once done file, we have a hash showing "B can be contained by ....."
#
# STEP 3: IMPLEMENT AN ALGORITHM TO FIND ALL BAGS RECURSIVELY
# Base case: If the bag cannot be contained within anything else, return empty array
# Recursive case: If the bag can be contained within other bags, return the union of the arrays of the bags, and the parent array itself
#
# Count the length of the array

require_relative "exercises"
require "pry"

class Exercise7 < Exercises
  data = parse_file("07-input.txt", "\n", false) # Array of rows
  data_test = parse_file("07-test.txt", "\n", false)

  def self.parse_line(line, trim_numbers) # str, bool
    split_line = line.split(" bags contain ")
    container = split_line[0]
    trimmed_line = trim_numbers ? split_line[1].sub(/ bags?\./, "").gsub(/\d /, "") : split_line[1].sub(/ bags?\./, "")
    contained_bags = trimmed_line.split(/ bags?, /)
    # puts "Container is #{container}"
    # p contained_bags
    {container: container, contained_bags: contained_bags}
  end

  # Generate rules for which bags can be contained in which
  def self.generate_container_rules(data)
    rules = Hash.new
    data.each do |rule|
      parsed_line = parse_line(rule, true)
      # Adds a rule "X => A, Y => A to show that X and Y can be contained by A."
      parsed_line[:contained_bags].each do |colour|
        rules[colour] ||= Array.new
        rules[colour].push parsed_line[:container]
      end
      # Handle edge case of "A contains no other bags."
      rules.delete("no other")
    end
    rules
  end

  # Generate rules for how many bags shall be stored inside a bag
  def self.generate_counting_rules(data)
    rules = Hash.new
    data.each do |rule|
      parsed_line = parse_line(rule, false)
      # Now we have {container: A, contained_bags: [4 B, 3 C, 2 D]}
      # First, handle the edge case where the bag contains no other bags
      if parsed_line[:contained_bags] == ["no other"]
        rules[parsed_line[:container]] = {}
      else
        parsed_line[:contained_bags].each do |bag_string|
          # Extract the number and colour from a string like "3 faded blue"
          num = bag_string.slice(/\d+/).to_i
          bag = bag_string.sub(/\d+ /, "")
          rules[parsed_line[:container]] ||= {}
          rules[parsed_line[:container]][bag] = num
        end
      end
    end
    rules
  end

  def self.find_container_bags(inner_bag, rules)
    if rules[inner_bag] 
      # Recursive case
      counts = rules[inner_bag].map do |parent|
        find_container_bags(parent, rules)
      end
      counts.reduce(:union).union rules[inner_bag]
    else
      # Base case
      []
    end
  end

  def self.count_contained_bags(container_bag, rules)
    child_bags_hash = rules[container_bag]
    if child_bags_hash.empty?
      # Base case
      0
    else
      # Recursive case
      count_array = child_bags_hash.map do |colour, number|
        number * count_contained_bags(colour, rules) + number
      end
      count_array.reduce(:+)
    end
  rescue
    puts "Couldn't find this colour"
    0
  end

  # Redundant method:
  # def self.contained_by?(contained_bag, container, rules)
  #   if contained_bag == container
  #     true
  #   else
  #     # Check whether the parent nodes (if "A can contain B, C, and D" and "F can contain B" then A & F are parents of B) can be contained by the container.
  #     rules[contained_bag].each do |parent|
  #       if contained_by?(parent, container, rules) 
  #         return true
  #       end
  #     end
  #     false
  #   end
  # rescue
  #   # puts "Error: Can't find bag type at #{contained_bag}"
  #   false
  # end

  # Test code
  # puts count_bags("shiny gold", rules)

  rulesA = generate_container_rules(data)
  solution1 = find_container_bags("shiny gold", rulesA)
  p solution1
  puts "#{solution1.length} bags found" # Output: 126 bags found

  # Test code
  # rulesB = generate_counting_rules(data_test)
  # p rulesB
  # solution2 = count_contained_bags("shiny gold", rulesB)
  # puts "#{solution2} bags within my bag"

  rulesB = generate_counting_rules(data)
  solution2 = count_contained_bags("shiny gold", rulesB)
  puts "#{solution2} bags within my bag" # Output: 220149 bags within my bag
  

end
