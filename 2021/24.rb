instructions = open("input").each_line.map(&:strip)

def execute_instructions(num, insts)
  num = num.to_s
  raise "Must be a 14-digit string with numerals 1 through 9" if num.chars.index("0") || num.length != 14
  input = num.chars
  settings = {"w" => 0, "x" => 0, "y" => 0, "z" => 0}
  insts.each do |inst|
    inst = inst.split(" ")
    arg = settings[inst[2]] || inst[2].to_i
    case inst[0]
    when "mul"
      settings[inst[1]] *= arg
    when "div"
      settings[inst[1]] = settings[inst[1]] / arg
    when "mod"
      settings[inst[1]] = settings[inst[1]] % arg
    when "add"
      settings[inst[1]] += arg
    when "eql"
      settings[inst[1]] = settings[inst[1]] == arg ? 1 : 0
    when "inp"
      settings[inst[1]] = input.shift.to_i
    else
      raise "ERROR"
    end
    p settings
  end
  settings
end

p execute_instructions(ARGV[0], instructions)