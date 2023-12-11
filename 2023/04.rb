cards = File.open("./04.txt").read.split("\n")
card_array = Array.new(cards.length, 1)
score = 0
cards.each_with_index do |card, ind|
  raw = card.split(":")[1]
  win_nums = raw.split("|")[0].split(" ").compact.map(&:to_i)
  my_nums = raw.split("|")[1].split(" ").compact.map(&:to_i)
  wins = (win_nums & my_nums).count
  (1..wins).each{card_array[ind + _1] += card_array[ind]}
  score += wins > 0 ? 2 ** (wins - 1) : 0
end
puts "Part 1: #{score}"
puts "Part 2: #{card_array.sum}"