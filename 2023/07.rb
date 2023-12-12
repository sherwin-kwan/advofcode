data = File.open("./07.txt").read.split("\n")
hands = data.map{_1.split(" ")[0]}

def score(hand, part) # This sorts hands from lowest to highest
  evaluation = hand.chars.tally.sort{|a, b| b[1] <=> a[1]}
  if part == 1
    return hand_rank(evaluation.map{_1[1]}).to_s + hand.gsub("K", "R").gsub("A", "S").gsub("T","I") # Artificial way of making AKQJT sort
  else
    pos_of_joker_card = evaluation.index{_1[0] != "J"}
    if pos_of_joker_card
      joker_card = evaluation[pos_of_joker_card][0]
      adjusted_hand = hand.gsub("J", joker_card)
      adjusted_evaluation = adjusted_hand.chars.tally.sort{|a, b| b[1] <=> a[1]}
      return hand_rank(adjusted_evaluation.map{_1[1]}).to_s + hand.gsub("K", "R").gsub("A", "S").gsub("T","I").gsub("J","1")
    else # Hand of all jokers! So business as usual
      return hand_rank(evaluation.map{_1[1]}).to_s + hand.gsub("K", "R").gsub("A", "S").gsub("T","I").gsub("J","1")
    end
  end
end

def hand_rank(combo)
  return 9 if combo[0] == 5 # five of a kind
  return 8 if combo[0] == 4 # four of a kind
  return 7 if combo[0] == 3 && combo[1] == 2 # full house, etc.
  return 6 if combo[0] == 3 
  return 5 if combo[0] == 2 && combo[1] == 2
  return 4 if combo[0] == 2 
  return 3
end

sorted_hands1 = hands.sort_by{score(_1, 1)}
scores1 = data.map do |line|
  hand, bid = line.split(" ")
  bid.to_i * (sorted_hands1.index(hand) + 1)
end

sorted_hands2 = hands.sort_by{score(_1, 2)}
scores2 = data.map do |line|
  hand, bid = line.split(" ")
  bid.to_i * (sorted_hands2.index(hand) + 1)
end
pp sorted_hands2

puts "Part 1: #{scores1.sum}"
puts "Part 2: #{scores2.sum}"