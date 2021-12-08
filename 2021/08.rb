    data = open("./08.txt").each_line.map{_1.split("|")}

    # Part 1
    p data.map {|line| line[1].strip.split(" ").count{[2, 3, 4, 7].include? _1.length}}.sum

    # Part 2
    def interpret(key, numeral)
      case numeral.length
      when 2
        "1"
      when 3
        "7"
      when 4
        "4"
      when 5
        return "3" if numeral.include?(key[:top_right]) && numeral.include?(key[:bot_right])
        return "2" if numeral.include?(key[:top_right]) && numeral.include?(key[:bot_left])
        return "5" if numeral.include?(key[:bot_right]) && numeral.include?(key[:top_left])
      when 6
        return "0" if !numeral.include?(key[:middle])
        return "6" if !numeral.include?(key[:top_right])
        return "9" if !numeral.include?(key[:bot_left])
      else
        "8"
      end
    end

    def decode_segments(line)
      tencodes = line[0].split(" ").sort{_1.length <=> _2.length}.map{_1.split("")}
      numerals = line[1].strip.split(" ")
      # Creates words of the following lengths: 2, 3, 4, 5, 5, 5, 6, 6, 6, 7 (corresponding to numerals 1, 7, 4, 2/3/5, 0/6/9, 8)
      letters = %w(a b c d e f g)
      dict = Hash.new
      dict[:top] = tencodes[1] - tencodes[0] # In 7 but not in 1
      dict[:bot_right] = tencodes[0] & tencodes[6] & tencodes[7] & tencodes[8] # In 0, 1, 6, and 8, etc.
      dict[:top_right] = tencodes[0] - dict[:bot_right]
      dict[:top_left] = tencodes[2] & tencodes[6] & tencodes[7] & tencodes[8] - tencodes[0] - dict[:top]
      dict[:middle] = tencodes[2] - tencodes[0] - dict[:top_left]
      dict[:bottom] = tencodes[3] & tencodes[4] & tencodes[5] - tencodes[1] - tencodes[2] 
      dict[:bot_left] = letters - dict[:top] - dict[:bot_right] - dict[:top_right] - dict[:top_left] - dict[:middle] - dict[:bottom]
      dict = dict.map{|k, v| [k, v.first]}.to_h # Each value in the dictionary is currently an array with 1 element, so map it into the actual element 
      numerals.map{interpret(dict, _1)}.join("").to_i
    end

    p data.sum{decode_segments(_1)}