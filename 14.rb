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
    p mask
    and_mask = mask.gsub(/X/, "1").to_i(2)
    or_mask = mask.gsub(/X/, "0").to_i(2)
    puts "And mask is #{and_mask}, Or mask is #{or_mask}"
    parsed_lines = Hash.new
    lines.each do |line|
      parsing = line.slice(4..-1).split("] = ")
      memory_location = parsing[0].to_i
      value = parsing[1].to_i
      parsed_lines[memory_location] = (value | or_mask) & and_mask
      puts "Changed #{memory_location} piece of memory to #{parsed_lines[memory_location]}"
    end
    parsed_lines
  end

  def self.compute_values(segments)
    memory = Hash.new
    # for (const segment of segments) {
    #   const newData = parseSegment(segment);
    #   console.log('new data is: ', newData);
    #   for (const key of Object.keys(newData)) {
    #     if (Object.keys(memory).includes(key)) {
    #       console.log('REPEAT KEY!!', key)
    #     }
    #   }
    #   memory = {...memory, ...newData};
    #   console.log(memory);
    # }
    # const sum = Object.values(memory).reduce((acc, val) => acc + val);
    # console.log(`Sum is ${sum}`);
    # return memory;
    segments.each do |segment|
      new_data = parse_segment(segment)
      p new_data
      new_data.each do |key, value|
        puts "Repeat key #{key}" if memory.keys.index(key)
        memory[key] = value
      end
      puts "Memory is now: "
      p memory
    end
    sum = memory.values.reduce(:+)
    puts "Sum is #{sum}"
    memory
  end

  segments = parse_data("./14-input.txt")
  segments_test = parse_data("./14-test.txt")
  # compute_values(segments_test)
  compute_values(segments)
end
