player1 = 5
player2 = 9

def next_spot(loc, roll)
  (loc + roll) % 10 == 0 ? 10 : (loc + roll) % 10
end

dice = [*1..100] * 1000
counter = pl1_score = pl2_score = 0
dice.each_slice(3) do |a|
  counter += 1
  if counter % 2 == 1
    player1 = next_spot(player1, a.sum)
    pl1_score += player1
    if pl1_score >= 1000
      puts counter * 3 * pl2_score
      break
    end
  else
    player2 = next_spot(player2, a.sum)
    pl2_score += player2
    if pl2_score >= 1000
      puts counter * 3 * pl1_score
      break
    end
  end
end

# Part 2

$cache = Hash.new
outcomes = [3, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 8, 8, 8, 9]
def scenarios(pl1, pl2, pl1_needed, pl2_needed, player_turn)
  if pl1_needed <= 0
    return 1
  elsif pl2_needed <= 0
    return 1.i
  end
  outcome = $cache[[pl1, pl2, pl1_needed, pl2_needed, player_turn]]
  if !outcome
    if player_turn == 1
      outcome = scenarios(next_spot(pl1, 3), pl2, pl1_needed - next_spot(pl1, 3), pl2_needed, 2)
      outcome += 3 * scenarios(next_spot(pl1, 4), pl2, pl1_needed - next_spot(pl1, 4), pl2_needed, 2)
      outcome += 6 * scenarios(next_spot(pl1, 5), pl2, pl1_needed - next_spot(pl1, 5), pl2_needed, 2)
      outcome += 7 * scenarios(next_spot(pl1, 6), pl2, pl1_needed - next_spot(pl1, 6), pl2_needed, 2)
      outcome += 6 * scenarios(next_spot(pl1, 7), pl2, pl1_needed - next_spot(pl1, 7), pl2_needed, 2)
      outcome += 3 * scenarios(next_spot(pl1, 8), pl2, pl1_needed - next_spot(pl1, 8), pl2_needed, 2)
      outcome += scenarios(next_spot(pl1, 9), pl2, pl1_needed - next_spot(pl1, 9), pl2_needed, 2)
    elsif player_turn == 2
      outcome = scenarios(pl1, next_spot(pl2, 3), pl1_needed, pl2_needed - next_spot(pl2, 3), 1)
      outcome += 3 * scenarios(pl1, next_spot(pl2, 4), pl1_needed, pl2_needed - next_spot(pl2, 4), 1)
      outcome += 6 * scenarios(pl1, next_spot(pl2, 5), pl1_needed, pl2_needed - next_spot(pl2, 5), 1)
      outcome += 7 * scenarios(pl1, next_spot(pl2, 6), pl1_needed, pl2_needed - next_spot(pl2, 6), 1)
      outcome += 6 * scenarios(pl1, next_spot(pl2, 7), pl1_needed, pl2_needed - next_spot(pl2, 7), 1)
      outcome += 3 * scenarios(pl1, next_spot(pl2, 8), pl1_needed, pl2_needed - next_spot(pl2, 8), 1)
      outcome += scenarios(pl1, next_spot(pl2, 9), pl1_needed, pl2_needed - next_spot(pl2, 9), 1)
    end
  end
  return outcome
end

stamp = Time.now
p scenarios(4, 8, 21, 21, 1)
p Time.now - stamp