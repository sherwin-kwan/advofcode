# First, decode rule 0:
# parse the file in a bottom-up way
# begin by looking for codes defined with no numbers, only letters
# mass replace that code wherever it appears
# Mass replace function:
# 1) Identify all occurrences of " 3". If 3 corresponds to a single string, replace all occurrences with that string.
# If 3 corresponds to one out of several strings (say, "a", "b", "c"), replace each element where " 3" occurs with three elements where " 3" is
# replaced with "a", "b", and "c" respectively
# Look for new codes only defined with letters, define it and mass replace
# Iterate until the problem is solved

# Next, take rest of file and count how many are identical to one of the strings in decoded rule 0

require_relative "exercises"
require "set"

raw_rules, messages = open('19-test.txt').read.split("\n\n").map {_1.split("\n")}
RULES = []
raw_rules.each do |rule| 
  index = rule.split(":").first.to_i 
  RULES[index] = rule.split(":").last.gsub("\"", "").strip # Puts the rules into a sorted array to make each rule easier to access
end

def parse_unit(unit)
  if unit.to_i > 0 # It's a number
    return RULES[unit.to_i]
  else # It's a string already
    return unit
  end
end

def parse_option(opt)
  opt.split(" ").map{parse_unit(_1)}
end

def parse_rule(rule)
  rule = [rule] if rule.class == String
  if rule.join("").match(/\d/)
    options = rule.map{_1.split(" | ")}
    options.map {|opt| parse_option(opt)}.flatten
  else
    return false # Already reduced to letters
  end
end

p RULES[0]
3.times do
  RULES[0] = parse_rule(RULES[0]) || break
  p RULES[0]
end

p RULES[0]

# class Exercise19 < Exercises
#   start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

#   def self.parse_data(fn)
#     rules, messages = parse_file(fn, "\n\n", false).map { |section| section.split("\n") }
#     rules.map! do |line|
#       line.gsub!(/\"/, "")
#       {
#         code: line.split(":")[0],
#         definitions: line.split(":")[1].split(" |"),
#       }
#     end
#     {
#       rules: rules.sort { |a, b| a[:code].to_i <=> b[:code].to_i },
#       messages: messages,
#     }
#   end

#   def self.letters_only(definitions)
#     definitions.each do |definition|
#       return false unless definition =~ /^[\D\s]+$/
#     end
#     true
#   end

#   def self.find_index_of_rule(rules, rule_num)
#     rules.index { |rule| rule[:code] == rule_num }
#   end

#   def self.decode(rules)
#     loop do
#       solved = rules.filter { |rule| letters_only(rule[:definitions]) }
#       rules = rules.filter { |rule| !letters_only(rule[:definitions]) }
#       solved_numbers = solved.map { |rule| rule[:code] }
#       p solved_numbers
#       solved.each do |solved_rule|
#         # Remove leading spaces from decoded rules (" a" => "a")
#         solved[find_index_of_rule(solved, solved_rule[:code])][:definitions].map! { |definition| definition.gsub(/\s/, "") }
#         rules.each_with_index do |rule|
#           new_definitions = rule[:definitions].flat_map do |definition|
#             options = Set.new
#             str_to_replace = /\b#{solved_rule[:code]}\b/
#             solved_rule[:definitions].each do |solved_definition|
#               options.add definition.gsub(str_to_replace, solved_definition)
#             end
#             options.to_a
#           end
#           rule[:definitions] = new_definitions
#         end
#       end
#       if find_index_of_rule(solved, "0")
#         solutions = solved[find_index_of_rule(solved, "0")][:definitions]
#         solutions.map {|solution| solution.gsub("\s", "")}
#         solutions.sort! {|a, b| a.length <=> b.length}
#         (0..10).each {|num| puts solutions[num]}
#         return solutions
#       end
#     end
#   end

#   def self.count_valid_messages(messages, definitions)
#     messages.filter { |message| definitions.include?(message) }.length
#   end

#   data = parse_data("./19-input.txt")
#   valid_phrases = decode(data[:rules])
#   (100000..1000100).each {|num| puts valid_phrases[num]}

#   puts "#{count_valid_messages(data[:messages], valid_phrases)} valid messages"

#   end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
#   puts "Elapsed time: #{end_time - start_time} seconds"
# end
