lines = File.open("./12.txt").read.split("\n")

def possible_arrangements(line, arr)
  regex = convert_to_regex(arr)
  questions = find_question_marks(line)
  counter = 0
  (0...2**(questions.length)).each do |trial|
    str = make_arrangement(line, questions, trial)
    if regex.match?(str)
      counter += 1
    end
  end
  return counter
end

def make_arrangement(line, questions, trial) # line, a reverse-sorted array of characters with ?, and the trial number
  new_line = line.dup
  binary = trial.to_s(2).reverse
  (0...questions.length).each do |bit|
    new_line[questions[bit]] = binary[bit] == "1" ? "#" : "."
  end
  return new_line
end

def find_question_marks(line)
  result = []
  (0...line.length).each { result.push(_1) if line[_1] == "?"}
  return result.sort.reverse
end

def convert_to_regex(arr)
  regex = "^\\.*" # Note the double \; this is necessary to escape the \ because I want to add a literal \ to the regex!
  arr.each_with_index do |num, ind|
    regex += "#" * num
    regex += "\\.+" unless ind == arr.length - 1
  end
  regex += "\\.*$"
  return eval("/#{regex}/")
end

counter = 0
arrs = lines.map do |line|
  counter += 1
  decode, raw_arr = line.split(" ")
  arr = eval("[#{raw_arr}]")
  puts counter if counter % 20 == 0
  possible_arrangements(decode, arr)
end
puts "Part 1: #{arrs.sum}"