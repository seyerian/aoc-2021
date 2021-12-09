class Aoc2021::Nine < Aoc2021::Solution
  alias Coord = NamedTuple(x: Int32, y: Int32)
  class Heightmap
    getter min_y : Int32,
           max_y : Int32,
           min_x : Int32,
           max_x : Int32
    def initialize(@raw : Array(Array(Char)))
      @min_y = 0
      @max_y = @raw.size - 1
      @min_x = 0
      # assuming rect
      @max_x = @raw[0].size - 1
    end

    def low_points
      low = [] of Coord
      @min_y.to @max_y do |y|
        @min_x.to @max_x do |x|
          coord = {x: x, y: y}
          if low_point?(coord)
            low << coord 
          end
        end
      end
      low
    end

    # sum of risk level of low points
    def total_risk_level
      low_points.sum do |low_point|
        risk_level(low_point)
      end
    end

    def low_point?(coord : Coord)
      val = get(coord)
      raise "Can't get lowness of coord off map: #{coord}" if val.nil?
      adjacents(coord).map { |c| get(c) }.compact.all? { |av| val < av }
    end 

    def adjacents(coord : Coord)
      x = coord[:x]
      y = coord[:y]
      [
        {x: x-1, y: y},
        {x: x+1, y: y},
        {x: x, y: y-1},
        {x: x, y: y+1}
      ]
    end

    def basins
      lows = low_points
      basin_arrs = Hash(Coord, Array(Coord)).new
      @min_y.to @max_y do |y|
        @min_x.to @max_x do |x|
          coord = {x: x, y: y}
          debug "finding basin for #{coord}"
          coord_val = get(coord)
          next if coord_val == 9
          next if coord_val.nil?
          path = coord
          if path.in?(lows)
            debug "coord in lows"
            basin_arrs[coord] ||= Array(Coord).new
            basin_arrs[coord] << coord
            next
          end
          loop do
            path = adjacents(path).min_by do |adj|
              val = get(adj)
              next 100 if val.nil?
              val
            end
            debug "pathing to #{path}"
            if path.in?(lows)
              debug "path in lows"
              basin_arrs[path] ||= Array(Coord).new
              basin_arrs[path] << coord
              break
            else
              path_val = get(path)
              raise "going upwards @ #{path}" if path_val.nil?
              raise "going upwards @ #{path}" if path_val >= coord_val
            end
          end
        end
      end
      basin_arrs
    end

    def risk_level(coord)
      val = get(coord)
      raise "Can't get risk level of coord off map: #{coord}" if val.nil?
      val + 1
    end

    def get(coord : Coord)
      x = coord[:x]
      y = coord[:y]
      return if x < min_x || x > max_x
      return if y < min_y || y > max_y
      if row = @raw[coord[:y]]?
        if val = row[coord[:x]]?
          val.to_i32
        end
      end
    end
  end

  def parse_input(file)
    InputParsers.map(file)
  end

  def part1(map)
    heightmap = Heightmap.new(map)
    heightmap.total_risk_level
  end

  def part2(map)
    heightmap = Heightmap.new(map)
    basins = heightmap.basins
    basin_sizes = basins.values.map(&.size).sort.reverse
    basin_sizes[0] * basin_sizes[1] * basin_sizes[2]
  end
end
