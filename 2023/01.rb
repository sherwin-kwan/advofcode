# Part 1 
rows = File.open("./01.txt").read.split("\n")
first_and_last_digits = rows.map{|row| row.split("").select{_1 == _1.to_i.to_s}.values_at(0, -1).reduce(&:+)}
puts first_and_last_digits.map(&:to_i).reduce(&:+)
# Part 2
NUMBERS_AS_WORDS = ["zero","one","two","three","four","five","six","seven","eight","nine"]
NUMBERS = (0..9).to_a
first_and_last_number_words = rows.map do |row|
  regex = /(?=(#{(NUMBERS_AS_WORDS + NUMBERS).join("|")}))/
  matches = row.scan(regex).values_at(0, -1).map{_1[0]}
  matches.map{_1.to_i.to_s == _1 ? _1.to_i : NUMBERS_AS_WORDS.index(_1)}.map(&:to_s).reduce(&:+).to_i
end
puts first_and_last_number_words.reduce(&:+)