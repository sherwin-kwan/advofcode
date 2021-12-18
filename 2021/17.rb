xrange, yrange = open("./17.txt").read.split(",").map{eval(_1.split("=").last)}

def triangular(n) = n * (n + 1) / 2
def loc(init_velocity, steps) = steps * (init_velocity - (steps - 1) / 2.0)

def possible_x(xrange)
  [*1..xrange.max].filter{|init_x| [*1..init_x].any?{xrange === loc(init_x, _1)}}
end

def target_hit?(init_x, init_y, xrange, yrange)
  (0..999).each do |steps|
    x = steps >= init_x ? triangular(init_x) : loc(init_x, steps)
    y = loc(init_y, steps)
    return true if xrange === x && yrange === y # At least one point in the target area
    return false if xrange.last < x || yrange.first > y # We don't need to check any further points, we're past the target area already
  end
  false
end

if [*1..xrange.min].any?{xrange === triangular(_1)} # I suspect everyone's puzzle input satisfies this, so there's a shortcut
  puts triangular(yrange.min)
else
  max_init_y = possible_x(xrange).map{|init_x| [*yrange.min..yrange.min.abs].filter{|init_y| target_hit?(init_x, init_y, xrange, yrange)}.max}.max
  puts triangular(max_init_y)
end
puts possible_x(xrange).sum{|init_x| [*yrange.min..yrange.min.abs].filter{|init_y| target_hit?(init_x, init_y, xrange, yrange)}.count}
