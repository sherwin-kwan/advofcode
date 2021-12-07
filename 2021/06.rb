$cache = Array.new(256)
def fish(days, initial_age = 0)
  if initial_age >= days
    1
  else # Look up an already-calculated result in the cache if possible; otherwise calculate it
    $cache[days] ||= fish(days - initial_age - 7) + fish(days - initial_age - 9)
  end
end
p File.open("./06.txt").read.split(",").map{fish(256, _1.to_i)}.reduce(&:+)