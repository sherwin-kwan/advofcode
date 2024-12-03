reports = File.open("02.txt").read.split("\n").map{_1.split(" ").map(&:to_i)}

def eval_report(report)
  if (report == report.sort || report == report.sort{|a, b| b <=> a})
    (0...report.length-1).each do |n|
      if (report[n+1] - report[n]).abs > 3 || report[n+1] == report[n]
        return 0
      end
    end
  else
    return 0
  end
  return 1
end

safe_num = reports.map{eval_report(_1)}.sum
puts "Part 1: #{safe_num}"

def eval_report_2(report)
  (0...report.length).each do |n|
    new_report = report.dup
    new_report.delete_at(n)
    return 1 if eval_report(new_report) == 1
  end
  return 0
end

safe_num = reports.map{eval_report_2(_1)}.sum
puts "Part 2: #{safe_num}"