# parse the file in a bottom-up way
# begin by looking for codes defined with no numbers, only letters
# mass replace that code wherever it appears
# Look for new codes only defined with letters, define it and mass replace
# Iterate until the problem is solved

require_relative 'exercises'

class Exercise19 < Exercises

  def self.parse_data(fn)
    data = parse_file(fn, "\n", false)
    data.map! do |line|
      line.gsub!(/\"/, "")
      {
        code: line.split(":")[0],
        definition: line.split(":")[1].split(" |")
      }
    end
    p data
    data
  end

  def self.letters_only(rule)
    rule[:definition].each do |definition|
      return false unless definition =~ /^[\D]+$/
    end
    true
  end

  def self.decode(data)
    solvable = data.filter_map { |rule| rule[:code] if letters_only(rule)}
    updated_portion = data.filter_map { |rule| }
    p solvable
  end

  decode(parse_data("./19-test.txt"))
end