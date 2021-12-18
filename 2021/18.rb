def snail_parse(str)
  counter = 0
  output = []
  str.chars.each do |char|
    if char.match?(/\d/)
      output << char.to_i + counter.i
    elsif char == "["
      counter += 1
    elsif char == "]"
      counter -= 1
    end
  end
  output
end

def snail_add(a, b)
  joined = a.dup.concat(b).map{_1 + 1.i}
  loop do 
    index_to_explode = joined.index{_1.imaginary >= 5}
    if index_to_explode
      explode(joined, index_to_explode) and next
    end
    index_to_split = joined.index{_1.real >= 10}
    if index_to_split
      split(joined, index_to_split) and next
    end
    break 
  end
  joined
end

def explode(arr, ind)
  first, second = arr.slice(ind, 2)
  arr[ind - 1] += first.real if ind != 0
  arr[ind + 2] += second.real if arr[ind + 2]
  arr.delete_at(ind)
  arr[ind] = 0 + (first.imaginary - 1).i
end

def split(arr, ind)
  arr.insert(ind + 1, (arr[ind].real / 2.0).round + (arr[ind].imaginary + 1).i)
  arr[ind] = arr[ind].real / 2 + (arr[ind].imaginary + 1).i
end

def get_magnitude(arr)
  loop do
    max_depth = arr.map(&:imaginary).max
    break if max_depth == 0
    ind = arr.index{ _1.imaginary == max_depth}
    arr[ind] = 3 * arr[ind].real + 2 * arr[ind + 1].real + (arr[ind].imaginary - 1).i
    arr.delete_at(ind + 1)
  end
  arr.first.real
end

# Part 1
data = open("./18.txt").each_line.map{snail_parse(_1)}
puts get_magnitude(data.reduce{snail_add(_1, _2)})
# Part 2
p data.permutation(2).map{|a, b| get_magnitude(snail_add(a, b))}.max