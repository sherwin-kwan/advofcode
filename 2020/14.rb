# Create an algorithm to do bit-masking using bitwise AND and OR operators
#   E.g. for the mask XXX1X0X, first do an AND with 1111101, then an OR with 0001000
#   Divide input file into a series of segments with newline + "mask" as a separator, each program having a separate mask
#   Then, parse each segment into a mask and an object with key (memory location) - value (value to input) pairs
#   Compute an AND and an OR version of each mask, substituting a "1" for each X in the AND version, and a "0" for each X in the OR version
#   Convert both masks to decimal
#   Create a separate object that represents the memory of the computer. It will have numerical keys which represent memory locations.
#   Iterate through the list of keys. For each key, set that memory location to the value OR (mask) AND (mask)
#   Iterate through all the segments
#   Use a reducer to sum the entire array of values saved in memory at the end of the program

require_relative "exercises"

class Exercise14 < Exercises
  def self.parse_data(fn)
    segments = parse_file(fn, "\nmask = ", false)
    segments[0].slice!(0..6)
    segments
  end

  def self.parse_segment(segment)
    lines = segment.split("\n")
    mask = lines.slice!(0)
    and_mask = mask.gsub(/X/, "1").to_i(2)
    or_mask = mask.gsub(/X/, "0").to_i(2)
    parsed_lines = Hash.new
    lines.each do |line|
      parsing = line.slice(4..-1).split("] = ")
      memory_location = parsing[0].to_i
      value = parsing[1].to_i
      parsed_lines[memory_location] = (value | or_mask) & and_mask
      puts "#{memory_location} piece of memory shall be set to #{parsed_lines[memory_location]}"
    end
    parsed_lines
  end

  def self.compute_values(segments, parsing_lambda)
    memory = Hash.new
    segments.each do |segment|
      new_data = parsing_lambda.call(segment)
      new_data.each do |key, value|
        puts "Repeat key #{key}" if memory.keys.index(key)
        memory[key] = value
      end
      puts "Memory is now: "
    end
    p memory
    sum = memory.values.reduce(:+)
    puts "Sum is #{sum}"
    memory
  end

  segments = parse_data("./14-input.txt")
  segments_test = parse_data("./14-test.txt")
  segments_test_2 = parse_data("./14-test-2.txt")
  # compute_values(segments_test)

  # PART 2
  # New parse segment method: 
  # Create an array to save a list of memory locations
  # Save the bits with the floating X in a separate array
  # Generate a "base" memory location by using the mask by setting all Xs to 1
  # Then, with a separate function, iterate through all the possible combinations of floating bits to generate an array of memory locations
  # Return a hash with key-value pairs for those memory locations
  # Then the previous method to set memory based on a hash with K-V pairs can be called. (so use a lambda)

  def self.parse_segment_v2(segment)
    lines = segment.split("\n")
    mask = lines.slice!(0)
    floating_bits = Array.new
    parsed_lines = Hash.new
    (0...mask.length).each do |ind|
      # 1 means the right-most bit (the units bit) is floating. 4294967296 means the fourth bit (the 2 ^ 32 bit) is floating. etc.
      floating_bits.push(2**ind) if mask.reverse[ind] == "X"
    end
    base_mask = mask.gsub(/X/, "1").to_i(2)
    lines.each do |line|
      parsing = line.slice(4..-1).split("] = ")
      value = parsing[1].to_i
      base = parsing[0].to_i | base_mask
      (0...2**(floating_bits.length)).each do |num|
        binary_string = num.to_s(2)
        memory_location = base - generate_offset(floating_bits, binary_string)
        parsed_lines[memory_location] = parsing[1].to_i
      end
    end
    p parsed_lines
    parsed_lines
  end

  def self.generate_offset(floating_bits, binary_string)
    offset = 0
    trial = binary_string.reverse.chars
    (0...trial.length).each do |ind|
      offset += floating_bits[ind] if trial[ind] == "1"
    end
    offset
  end


  compute_values(segments, method(:parse_segment)) # Output: Sum is 12512013221615
  compute_values(segments, method(:parse_segment_v2)) # Output: Sum is 3905642473893
end
