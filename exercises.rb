# Master class with methods for all exercises
class Exercises

  def self.parse_file(fn, separator, log)
    data = open(fn).read.split(separator)
    p data if log
    data
  end
end