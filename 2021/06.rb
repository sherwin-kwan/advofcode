$cache = Array.new(256)
def time_series(days, initial_age = 0)
  if initial_age >= days
    1
  else # Look up an already-calculated result in the cache if possible; otherwise calculate it
    $cache[days] ||= time_series(days - initial_age - 7) + time_series(days - initial_age - 9)
  end
end
p File.open("./06.txt").read.split(",").map(&:to_i).map{time_series(256, _1)}.reduce(&:+)