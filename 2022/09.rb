class RopeStateMachine
  attr_accessor :total, :step, :state, :next_sm
  def initialize(next_sm: nil)
    if next_sm
      @next_sm = next_sm
    else
      @visited = Array.new(2000){Array.new(2000){0}}
      @tail = {x: 1000, y: 1000}
    end
    @state = {x: 0, y: 0} # Location of head relative to following position of rope (which is tail in Part 1) when initialized
  end

  def transition_to(state)
    if state[:x].abs == 2 && state[:y] == 0
      if @next_sm
        @next_sm.transition_to(x: @next_sm.state[:x] + state[:x] / 2, y: @next_sm.state[:y])
      else
        @tail[:x] += state[:x]/2
      end
      transition_to({x: state[:x]/2, y: 0})
    elsif state[:y].abs == 2 && state[:x] == 0
      if @next_sm
        @next_sm.transition_to(x: @next_sm.state[:x], y: @next_sm.state[:y] + state[:y] / 2)
      else
        @tail[:y] += state[:y]/2
      end
      transition_to({y: state[:y]/2, x: 0})
    elsif state[:x].abs + state[:y].abs > 2
      right = state[:x] > 0 ? 1 : -1
      up = state[:y] > 0 ? 1 : -1
      if @next_sm
        @next_sm.transition_to(x: @next_sm.state[:x] + right, y: @next_sm.state[:y] + up)
      else
        @tail[:x] += right
        @tail[:y] += up
      end
      transition_to({x: state[:x] - right, y: state[:y] - up})
    else
      unless @next_sm
        @visited[@tail[:x]][@tail[:y]] = 1
      end
      @state = state
    end
  end

  def step(inst)
    dir, mag = inst.split(" ")
    mag.to_i.times do
      case dir
      when "R"
        transition_to({x: @state[:x] + 1, y: @state[:y]})
      when "L"
        transition_to({x: @state[:x] - 1, y: @state[:y]})
      when "U"
        transition_to({x: @state[:x], y: @state[:y] + 1})
      when "D"
        transition_to({x: @state[:x], y: @state[:y] - 1})
      end
    end
  end

  def total = @visited.map(&:sum).sum
end

input = File.open("./09.txt")
rsm = RopeStateMachine.new
rsm_p2 = [RopeStateMachine.new]
8.times do
  rsm_p2.unshift(RopeStateMachine.new(next_sm: rsm_p2[0]))
end
input.each_line do |line|
  rsm.step(line)
  rsm_p2[0].step(line)
end
puts "Part 1: #{rsm.total}"
puts "Part 2: #{rsm_p2.last.total}"