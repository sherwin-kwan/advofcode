$directories = {}

class Folder
  attr_accessor :total_size, :file_size
  def initialize(path:)
    @path = path
    @files = []
    @subdirectories = []
    $directories[path] = self
    @file_size = 0
  end

  def add_directory(name:) = @subdirectories.push(Folder.new(path: @path.dup.push(name)))
  def total_size = @subdirectories.map(&:total_size).sum + file_size
end

raw_input = File.open("./07.txt").read[1..-1].split("\n$")
current_path = []
Folder.new(path: [])
raw_input.each do |part|
  if part[0..2] == " cd"
    case rel_path = part.gsub(" cd ", "")
    when ".."
      current_path.pop
    when "/"
      current_path = []
    else
      current_path.push(rel_path)
    end
  else # so it's ls
    nodes = part.split("\n")[1..-1]
    nodes.each do |node|
      if node[0..2] == "dir"
        name = node.gsub("dir ", "")
        $directories[current_path].add_directory(name:name)
      else
        size = node.split(" ")[0]
        $directories[current_path].file_size += size.to_i
      end
    end
  end
end

puts "Part 1: #{$directories.values.select{_1.total_size < 100000}.map(&:total_size).sum}"
memory_to_delete = $directories[[]].total_size - 40000000
puts "Part 2: #{$directories.values.map(&:total_size).sort.find{_1 >= memory_to_delete}}"