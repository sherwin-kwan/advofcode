rules, updates = File.open("05.txt").read.split("\n\n")
master_rule_library = {}
rules.split("\n").each do |rule|
  a, b = rule.split("|")
  master_rule_library[a] ||= []
  master_rule_library[a] << b
end

def find_sort(library, arr)
  copy_of_library = library.dup
  library.keys.each do |key|
    if arr.include?(key)
      copy_of_library[key] = copy_of_library[key].intersection(arr)
    else
      copy_of_library.delete(key)
    end
  end
  the_sort = copy_of_library.keys.sort{|a, b| copy_of_library[b].length <=> copy_of_library[a].length}
  the_sort << arr.filter{!the_sort.include?(_1)}.first
  return the_sort
end

def check_update_v1(update, library)
  the_sort = find_sort(library, update)
  return the_sort.intersection(update) == update ? update[update.length / 2].to_i : 0
end

def check_update_v2(update, library)
  the_sort = find_sort(library, update)
  sorted_update = the_sort.intersection(update)
  return sorted_update == update ? 0 : sorted_update[update.length / 2].to_i
end

p1 = updates.split("\n").map{|row| check_update_v1(row.split(","), master_rule_library)}.sum
puts "Part 1: #{p1}"
p2 = updates.split("\n").map{|row| check_update_v2(row.split(","), master_rule_library)}.sum
puts "Part 2: #{p2}"
