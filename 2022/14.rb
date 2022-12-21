h = Hash.new(nil)

input = File.open("./14.txt").read.split("\n")
$max_y = 0
input.each do |line|
  coords = line.split(" -> ")
  coords.each_cons(2).each do |pair|
    a, b = pair[0].split(",").map(&:to_i)
    $max_y = b if b > $max_y
    coord1 = Complex(a, b)
    a, b = pair[1].split(",").map(&:to_i)
    $max_y = b if b > $max_y
    coord2 = Complex(a, b)
    dist = (coord2.real - coord1.real).abs
    dist = (coord2.imaginary - coord1.imaginary).abs if dist == 0
    (0..dist).each do |p| 
      mid = Complex(coord1.real + ((coord2.real-coord1.real) * p)/ dist, coord1.imaginary + ((coord2.imaginary-coord1.imaginary) *p )/ dist )
      h[mid] = true
    end
  end
end

def find_resting_place(h)
  n = 0
  x = 500
  y = 0
  loop do
    return nil if y > ($max_y + 3)
    n += 1
    unless h[Complex(x, y+1)]
      y += 1 
      next
    end
    unless h[Complex(x-1, y+1)]
      y += 1
      x -= 1 
      next
    end
    unless h[Complex(x+1, y+1)]
      y += 1
      x += 1 
      next
    end
    return Complex(x, y)
  end
end

k = 0
h2 = h.dup
loop do 
  frp = find_resting_place(h)
  break unless frp
  k += 1
  h[frp] = true
end
puts "Part 1: #{k}"
(500-($max_y + 3)..500+($max_y+3)).each do |x|
  h2[Complex(x, $max_y + 2)] = true
end
k = 0
loop do 
  frp = find_resting_place(h2)
  break unless frp
  k += 1
  break if frp == 500
  h2[frp] = true
end
puts "Part 2: #{k}"