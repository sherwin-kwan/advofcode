# Begin by parsing the allergens file into an array of arrays
# Each line contains a (contains ... ), use that to parse a list of allergens
# For all the text before the "(", use spaces to separate out the ingredients
# So each food is saved as {:ingredients => [], :allergens => [] }
# Use map & union to find a list of all allergens
# For each allergen, filter_map to get a list of ingredient lists, every list within which must contain the allergen.
# Then do intersection to find candidates for the allergen
# Print results to see if it can be solved manually
# If not, find an allergen with only a single ingredient candidate.
# Create a new array for confirmed allergen-containing ingredients, and push this candidate
# Map to eliminate that ingredient candidate from all the other candidate arrays
# Iterate until all allergens have been associated with a single ingredient, which is pushed to an allergen-containing ingredients array
# Do a final map to identify the number of ingredients in each food which are not allergen-containing, then reduce to solve Part 1

require_relative "exercises"

class Exercise21 < Exercises
  def self.parse_input(fn)
    data = parse_file(fn, "\n", false)
    data.map! do |food|
      ingredients = food.split(/\(contains\s/)[0].split(" ")
      allergens = food.split(/\(contains\s/)[1].sub(/\)/, "").split(", ")
      { ingredients: ingredients, allergens: allergens }
    end
    data
  end

  def self.identify_allergens(data)
    allergens_data = data.map { |food| food[:allergens] }.reduce { |acc, val| acc | val }
    allergen_candidates = allergens_data.map do |allergen|
      candidates = data.filter_map { |food| food[:ingredients] if food[:allergens].include?(allergen) }.reduce { |acc, val| acc & val }
      { allergen: allergen, candidates: candidates }
    end
    rosetta_stone = Hash.new
    loop do
      break if allergen_candidates.length == 0
      allergen_candidates.sort! { |a, b| a[:candidates].length <=> b[:candidates].length }
      allergen = allergen_candidates[0]
      if allergen[:candidates].length == 1
        # Allergen identified!
        found = allergen[:candidates][0]
        rosetta_stone[allergen[:allergen]] = found
        allergen_candidates.delete allergen
        allergen_candidates.map! do |all|
          all[:candidates].delete found
          all
        end
      end
    end
    rosetta_stone
  end

  def self.count_healthy_ingredients(data, unwanted_ingredients)
    count = data.reduce(0) do |acc, val|
      acc + (val[:ingredients] - unwanted_ingredients).length
    end
    puts "Total ingredients after allergen-containing ones are removed are #{count}"
  end

  def self.canonical_dangerous_list(rosetta_stone)
    rosetta_stone.sort_by {|k, v| k}.map {|all| all[1]}.join(",")
  end

  data = parse_input("./21-input.txt")
  rosetta_stone = identify_allergens data
  count_healthy_ingredients(data, rosetta_stone.values)
  puts "The ban list is: #{canonical_dangerous_list(rosetta_stone)}"
#   Output:
#   Total ingredients after allergen-containing ones are removed are 2374
# The canonical ban list is: ccrbr,cpttmnv,fbtqkzc,jbbsjh,mzqjxq,nlph,tdmqcl,vnjxjg

end
