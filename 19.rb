# parse the file in a bottom-up way
# begin by looking for codes defined with no numbers, only letters
# mass replace that code wherever it appears
# Mass replace function:
# 1) Identify all occurrences of " 3". If 3 corresponds to a single string, replace all occurrences with that string.
# If 3 corresponds to one out of several strings (say, "a", "b", "c"), replace each element where " 3" occurs with three elements where " 3" is
# replaced with "a", "b", and "c" respectively
# Look for new codes only defined with letters, define it and mass replace
# Iterate until the problem is solved

require_relative "exercises"
require "set"

class Exercise19 < Exercises
  def self.parse_data(fn)
    data = parse_file(fn, "\n", false)
    data.map! do |line|
      line.gsub!(/\"/, "")
      {
        code: line.split(":")[0],
        definitions: line.split(":")[1].split(" |"),
      }
    end
    p data
    data
  end

  def self.letters_only(definitions)
    definitions.each do |definition|
      return false unless definition =~ /^\D+$/
    end
    true
  end

  def self.decode(data)
    5.times do
      solvable = data.filter { |rule| letters_only(rule[:definitions]) }
      p solvable

      solvable.each do |solved_rule|
        # Remove leading spaces from decoded rules (" a" => "a")
        data[solved_rule[:code].to_i][:definitions].map! { |definition| definition.gsub(/\s/, "") }
        data.each do |rule|
          new_definitions = rule[:definitions].flat_map do |definition|
            options = Set.new
            str_to_replace = /\s#{solved_rule[:code]}/
            solved_rule[:definitions].each do |solved_definition|
              options.add definition.gsub(str_to_replace, solved_definition)
            end
            options.to_a
          end
          rule[:definitions] = new_definitions
        end
        p data
      end

    end
  end

  decode(parse_data("./19-test.txt"))
end
