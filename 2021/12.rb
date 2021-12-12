class Cave
  def initialize(file)
    @network = Hash.new
    open(file).each_line.map{_1.strip.split("-")}.each_with_index{|route| add_route(route.first, route.last) && add_route(route.last, route.first)}
  end

  def add_route(a, b)
    @network[a] ? @network[a] << b : @network[a] = [b]
  end

  def extend_route(route, part_num)
    if route.last == "end"
      @final_routes.push(route)
      return
    end
    legal_next_steps = @network[route.last].filter do |dest|
      minor_cave_violation = false
      if dest == dest.downcase
        lowercase_caves = route.filter{_1 == _1.downcase}
        if (lowercase_caves.count == lowercase_caves.uniq.count ) && part_num == 2
          minor_cave_violation = route.each_index.filter{route[_1] == dest}.count > 1
        else
          minor_cave_violation = route.include?(dest)
        end
      end
      dest != "start" && !minor_cave_violation 
    end
    return legal_next_steps.map{|ns| [*route, ns]}
  end

  def solve(part_num)
    routes = [["start"]]
    @final_routes = []
    loop do
      routes = routes.map{extend_route(_1, part_num)&.compact}.compact.reduce([]){|acc, val| acc.concat(val)}
      break if routes.empty?
    end
    p @final_routes.count
  end

end

c = Cave.new("./12.txt")
c.solve(1)
c.solve(2)