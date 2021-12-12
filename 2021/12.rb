class Cave
  def initialize(file)
    @network = Hash.new
    @caves = open(file).each_line.map{_1.strip.split("-")}.unshift(nil)
    @caves.each_with_index{|route, ind| ind > 0 && add_route(route.first, ind) && add_route(route.last, -ind)}
    @routes = [[]]
    @final_routes = []
  end

  def add_route(a, ind)
    if @network[a]
      @network[a] << ind
    else
      @network[a] = [ind]
    end
  end

  def extend_route(route)
    current = route.length == 0 ? "start" : route.last > 0 ? @caves[route.last].last : @caves[-route.last].first
    if current == "end"
      @final_routes.push(route)
      return
    end
    # Part 1
    legal_next_steps = @network[current].filter do |poss|
      destination = poss > 0 ? @caves[poss].last : @caves[-poss].first
      !route.include?(poss) && (destination != destination.downcase || (@network[destination] & route).empty?)
    end
    # Part 2
    # legal_next_steps.each{|ns| @routes_to_add.push([*route, ns])}
  end

  def solve
    loop do
      @routes_to_add = []
      @routes.each{extend_route(_1)}
      break if @routes_to_add.empty?
      @routes = @routes_to_add
    end
    p @final_routes.count
  end

end

c = Cave.new("./12.txt")
c.solve