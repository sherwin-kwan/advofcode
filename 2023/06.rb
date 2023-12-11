def ways_to_beat_record(secs, record)
  max_possible = (secs / 2) ** 2
  return 0 if record > max_possible # Means record can't be beat
  poss = Integer.sqrt(max_possible - record) * 2
  return secs % 2 == 0 ? poss + 1 : poss
end
puts "Part 1: #{ways_to_beat_record(71530,940200)}"
puts "Part 2: #{ways_to_beat_record(47707566,282107911471062)}" # Just copied from the files lol, easier than having to read and parse it