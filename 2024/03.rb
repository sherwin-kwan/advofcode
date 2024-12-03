def parse_program_for_sum_of_products(program)
  total_prod = 0
  matches = program.scan(/mul\(\d+,\d+\)/)
  matches.map do |match|
    /mul\((\d+),(\d+)\)/ =~ match
    product = $1.to_i * $2.to_i
    total_prod += product
  end
  return total_prod
end

program = File.open("03.txt").read
puts "Part 1: #{parse_program_for_sum_of_products(program)}"

enabled = program.gsub("\n","").gsub(/don't\(\).*?do\(\)/, "").gsub(/don't\(\).*?$/,"")
puts "Part 2: #{parse_program_for_sum_of_products(enabled)}"
