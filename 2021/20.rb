    alg, data = open("./20.txt").read.split("\n\n").map{_1.gsub(".", "0").gsub("#", "1").split("\n")}
    alg = alg.join("")
    rows = data.count
    input_image = Hash.new(0)
    data.each_with_index do |row, i|
      row.chars.each_with_index do |col, j|
        input_image[i + j.i] = col.to_i
      end
    end

    def read_neighbours(c)
      return [c - 1 - 1.i, c - 1, c + 1.i - 1, c - 1.i, c, c + 1.i, c + 1 - 1.i, c + 1, c + 1 + 1.i]
    end

    def transform(input, alg, rows, step)
      orig_default = input[20000 + 1.i]
      output = Hash.new(1 - orig_default)
      [*0 - step...rows + step].each do |row|
        [*0 - step...rows + step].each do |col|
          lookup = read_neighbours(row + col.i).map{input[_1].to_s}.join("").to_i(2)
          output[row + col.i] = alg[lookup]
        end
      end
      output
    end

    stamp = Time.now
    (1..50).each{|n| input_image = transform(input_image, alg, rows, n)}
    p input_image.values.tally
    puts Time.now - stamp