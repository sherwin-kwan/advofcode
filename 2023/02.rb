games = File.open("./02.txt").read.split("\n").map{_1.split(":")[1]}
COLOURS = ["red", "blue", "green"]
TOTALS = {red: 12, green: 13, blue: 14}
valid_games = 0
powers = 0
games.each_with_index do |game, ind|
  most = {red: 0, blue: 0, green: 0}
  trials = game.split(";")
  trials.each do |trial|
    viewings = trial.split(",")
    viewings.each do |viewing|
      raise "STOP" unless COLOURS.include?(viewing.strip.split(" ")[1])
      most[viewing.strip.split(" ")[1].to_sym] = [most[viewing.strip.split(" ")[1].to_sym], viewing.strip.split(" ")[0].to_i].max
    end
  end
  valid_games += (ind + 1) if COLOURS.all?{TOTALS[_1.to_sym] >= most[_1.to_sym]}
  powers += most.values.reduce(&:*)
end
puts "Part 1: #{valid_games}"
puts "Part 2: #{powers}"