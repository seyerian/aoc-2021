class Aoc2021::Fifteen < Aoc2021::Solution
  def parse_input(file)
    Map.new(InputParsers.map(file))
  end

  #UNREACHABLE = (Int64::MAX / 2).to_i64
  
  BASE_COST = 1_000_000

  class PathNode
    def_clone
    property coords : Coord
    property parent : (PathNode|Nil)
    property visited : Bool
    property cost : Int32
    property risk : Int32
    property heuristic : Int32
    def initialize(@coords)
      @visited = false
      @cost = BASE_COST
      @risk = 0
      @heuristic = 0_i32
    end
    def neighbor_of?(other : PathNode)
      (coords.x - other.coords.x).abs + (coords.y - other.coords.y).abs <= 1
    end
    def ==(other : PathNode)
      coords == other.coords
    end
    def score
      cost + heuristic
    end
  end

  # A* pathfind
  def find_path(map : Map, start : Coord, finish : Coord)
    visited = Array(PathNode).new
    unvisited = Array(PathNode).new

    map.each do |val, coords|
      node = PathNode.new(coords)
      risk = map.get(coords)
      raise "NO RISK FOR NODE" if risk.nil?
      node.risk = risk.to_i32
      node.heuristic = yield(node.coords) || 0_i32
      unvisited << node
    end

    current = unvisited.find do |n|
      n.coords == start
    end
    return unless current
    current.cost = 0_i32

    found = false
    until found # main loop
      # get neighbors of current node, and update their cost if
      # the path through the current node is shorter than their existing cost.
      neighbor_coords = map.neighbors(current.coords, diagonal: false)
      neighbors = unvisited.select do |n|
        next false if n == current
        neighbor_coords.includes?(n.coords)
      end
      neighbors.each do |neighbor|
        cost = neighbor.risk
        if current.cost + cost < neighbor.cost
          neighbor.cost = current.cost + cost
          neighbor.parent = current
        end
      end

      # mark current node as visited
      current.visited = true
      unvisited.delete(current)
      visited << current

      # pick a new current node
      return if unvisited.size == 0
      unvisited.sort_by!(&.score)
      part = unvisited.partition { |n| n.cost < BASE_COST }
      unvisited = part.first.sort_by(&.score) + part.last

      closest = unvisited.first

      return if closest.nil?
      current = closest

      # block indicates whether we found target
      found = true if current.coords == finish
    end # main loop

    # return path from current node back to starting node
    path = Array(PathNode).new
    parent = current
    while !parent.nil?
      path << parent
      parent = parent.parent
    end
    path.reverse
  end

  def part1(map)
    start = {x: 0, y: 0}
    finish = {x: map.max_x, y: map.max_y}
    max = (map.max_x + map.max_y).to_i32
    path = find_path(map, start, finish) do |coords|
      bottom_right_factor = (
        (max - (map.max_y - coords[:y]) + (map.max_x - coords[:x])) / max * 10
      ).to_i32
      center_line_factor = (coords[:y] - coords[:x]).abs
      bottom_right_factor + center_line_factor 
    end
    raise "ERROR" if path.nil?
    path.last.cost
  end

  def part2(map)
    larger_map = Map.new(map.width * 5, map.height * 5)

    map.each do |val, coords|
      (0..4).each do |y|
        (0..4).each do |x|
          new_val = val + x + y
          while new_val > 9
            new_val -= 9 
          end
          larger_map.set(
            {
              x: coords[:x] + (map.width * x),
              y: coords[:y] + (map.height * y)
            },
            new_val
          )
        end
      end
    end

    #larger_map.draw

    start = {x: 0, y: 0}
    finish = {x: larger_map.max_x, y: larger_map.max_y}
    max = (map.max_x + map.max_y).to_i32
    path = find_path(larger_map, start, finish) do |coords|
      bottom_right_factor = (
        (max - (map.max_y - coords[:y]) + (map.max_x - coords[:x])) / max * 10
      ).to_i32
      center_line_factor = (coords[:y] - coords[:x]).abs
      bottom_right_factor + center_line_factor 
    end
    raise "ERROR" if path.nil?
    path.last.cost
  end
end
