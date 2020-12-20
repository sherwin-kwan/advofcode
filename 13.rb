require_relative "exercises"

# parse the file, first by newline, then turn the second line into an array with a splat
# replace all the Xs with 0 and type-cast to numeric
# sort the array to get a series of bus numbers
# create a second array, with number - timestamp % number, to find the number of minutes you have to wait for that bus
# find the shortest wait time and multiply it by the bus number

# Part B:
# Extract the index of the bus numbers from the raw data
# Start with the two biggest numbers


class Exercise13 < Exercises
  def self.parse_text(fn)
    data = parse_file(fn, /[\n,]/, false)
    timestamp = data.slice!(0).to_i
    { timestamp: timestamp, data: data }
  end

  def self.find_buses(input_data)
    data = input_data.map {|str| str.to_i} # Xs will turn into zeroes
    first_zero = data.sort! { |a, b| b <=> a}.index(0)
    data.slice(0, first_zero - 1) # Discard the trailing zeroes
  end

  def self.wait_times(timestamp, buses)
    buses.map do |num|
      num - timestamp % num
    end
  end

  def self.solveA(timestamp, buses)
    wait_times = wait_times(timestamp, buses)
    index_of_quickest_bus = wait_times.index(wait_times.min)
    quickest_bus = buses[index_of_quickest_bus]
    puts "#{wait_times.min} minute wait to catch bus #{quickest_bus}, so the answer is #{wait_times.min * quickest_bus}"
  end

  def self.solveB(data)

  end

  timestamp, data = parse_text("./13-input.txt").values_at(:timestamp, :data)
  solveA(timestamp, find_buses(data))
end
