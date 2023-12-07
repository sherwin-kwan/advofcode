map, inst = File.open("./22.txt").read.split("\n\n")
map = map.split("\n")
$height = map.length
$width = map.first.length
h = {}
map.each_with_index do |line, row|
  line.split("").each_with_index do |char, col|
    case char
    when "."
      h[row+col.i] = 1
    when "#"
      h[row+col.i] = 0
    else
    end
  end
end

$pos = h.keys.first
$facing = 0

def change_dir(char)
  case char
  when "R"
    $facing = ($facing + 1) % 4
  when "L"
    $facing = ($facing - 1) % 4
  end
end

def around_the_cube
  if $pos.real == 0 && $pos.imaginary < 100 && $facing == 3 # top edge A
    return [$pos.imaginary + 100 + 0.i, 0]
  elsif $pos.real == 0 && $facing == 3 # top side B
    return [199 + ($pos.imaginary-100).i, 3]
  elsif $pos.imaginary == 149 && $facing == 0 # right side B
    return [149 - $pos.real + 99.i, 2]
  elsif $pos.real == 49 && $facing == 1 # bottom side B
    return [$pos.imaginary - 50 + 99.i, 2]
  elsif $pos.imaginary == 99 && $pos.real < 100 # right side C
    return [49 + ($pos.real - 50).i, 3]
  elsif $pos.imaginary == 99 && $facing == 0 # right side D
    return [149 - $pos.real + 149.i , 2]
  elsif $pos.real == 149 && $pos.imaginary > 49 && $facing == 1 # bottom side D
    return [$pos.imaginary + 100 + 49.i, 2]
  elsif $pos.imaginary == 49 && $pos.real > 149 && $facing == 0 # right side F
    return [149 + ($pos.real - 100).i, 3]
  elsif $pos.real == 199 && $facing == 1 # bottom side F
    return [($pos.imaginary + 100).i, 1]
  elsif $pos.imaginary == 0 && $pos.real > 149 && $facing == 2 # left side F
    return [($pos.real - 100).i, 1]
  elsif $pos.imaginary == 0 && $facing == 2 # left side E
    return [(149 - $pos.real) + 50.i, 0]
  elsif $pos.real == 100 && $facing == 3 # top side E
    return [$pos.imaginary + 50 + 50.i, 0]
  elsif $pos.imaginary == 50 && $pos.real > 49 # left side C
    return [100 + ($pos.real - 50).i, 1]
  elsif $pos.imaginary == 50 && $facing == 2 # left side A
    return [149 - $pos.real + 0.i, 0]
  end
end

def walk(h, part)
  np = -1
  nf = -1
  trigger = false
  case $facing
  when 0
    np = $pos + 1.i
    if !h[np]
      if part == 1
        col = (0..$width - 1).to_a.find{h[$pos.real + _1.i]}
        np = $pos.real + col.i
      else
        trigger = true
        np, nf = around_the_cube
        pp [np, nf]
        puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      end
    end
  when 1
    np = $pos + 1
    if !h[np]
      if part == 1
        row = (0..$height - 1).to_a.find{h[_1 + $pos.imaginary.i]}
        np = row + $pos.imaginary.i
      else
        trigger = true
        np, nf = around_the_cube
        pp [np, nf]
        puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      end
    end
  when 2
    np = $pos - 1.i
    if !h[np]
      if part == 1
        col = (0..$width - 1).to_a.reverse.find{h[$pos.real + _1.i]}
        np = $pos.real + col.i
      else
        trigger = true
        np, nf = around_the_cube
        pp [np, nf]
        puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      end
    end
  when 3
    np = $pos - 1
    if !h[np]
      if part == 1
        row = (0..$height - 1).to_a.reverse.find{h[_1 + $pos.imaginary.i]}
        np = row + $pos.imaginary.i
      else
        trigger = true
        np, nf = around_the_cube
        pp [np, nf]
        puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      end
    end
  else
    puts $facing
    puts "STOP"
  end
  if h[np] == 1
    puts "NP at #{np}"
    $pos = np
    $facing = nf if nf != -1
    puts "Changed facing to #{$facing}" if trigger
  else
    raise "Hit a wall!"
  end
end

steps = inst.scan(/\d+[RL]/)
puts "Starting at: #{$pos.to_s}"
steps.each do |step|
  paces = step.to_i
  dir = step.gsub(paces.to_s, "")
  begin
    paces.times{walk(h, 1)}
    puts "Reached #{$pos.to_s}"
  rescue => e
    puts "Hit a wall at #{$pos.to_s}"
  end
  change_dir(dir)
  puts "New facing: #{$facing.to_s}"
end

puts "Part 1: #{($pos.real + 1) * 1000 + ($pos.imaginary + 1) * 4 + $facing}"

# $pos = h.keys.first
# $facing = 0
# steps.each do |step|
#   paces = step.to_i
#   dir = step.gsub(paces.to_s, "")
#   puts "Instruction: #{step}"
#   begin
#     paces.times{walk(h, 2)}
#     puts "Reached #{$pos.to_s}"
#   rescue => e
#     puts "Hit a wall at #{$pos.to_s}"
#   end
#   change_dir(dir)
#   puts "New facing: #{$facing.to_s}"
# end
# puts "Part 2: #{($pos.real + 1) * 1000 + ($pos.imaginary + 1) * 4 + $facing}"