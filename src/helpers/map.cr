module Aoc2021
  class Map
    def_clone

    property map : Hash(Int32, Hash(Int32, Char))

    getter min_y : Int32, max_y : Int32, min_x : Int32, max_x : Int32

    def initialize()
      @map = Hash(Int32, Hash(Int32, Char)).new
      @min_y = 0
      @max_y = 0
      @min_x = 0
      @max_x = 0
    end

    def initialize(map : Array(Array(Char)))
      @map = Hash(Int32, Hash(Int32, Char)).new
      map.each.with_index do |row, y|
        @map[y] = Hash(Int32, Char).new
        row.each.with_index do |char, x|
          @map[y][x] = char
        end
      end
      y_a = @map.keys
      x_a = @map.values.map(&.keys).flatten.uniq
      @min_y = y_a.min
      @max_y = y_a.max
      @min_x = x_a.min
      @max_x = x_a.max
    end

    def ==(other : Map)
      @map == other.map
    end

    def extend_bounds(coord)
      #y_a = @map.keys
      #x_a = @map.values.map(&.keys).flatten.uniq
      y_a = [coord[:y], min_y, max_y]
      x_a = [coord[:x], min_x, max_x]
      @min_y = y_a.min
      @max_y = y_a.max
      @min_x = x_a.min
      @max_x = x_a.max
    end

    def draw
      (min_y..max_y).each do |y|
        debug_buffered ""
        (min_x..max_x).each do |x|
          debug_buffered get({x: x, y: y}), print: true
        end
      end
      debug_flush
    end

    def each
      map.each do |y, row|
        row.each do |x, val|
          yield val, {x: x, y: y}
        end
      end
    end

    def get(coord, default = '.')
      if (row = map[coord[:y]]?)
        if (val = row[coord[:x]]?)
          return val
        end
      end
      default
    end

    def set(coord, val)
      map[coord[:y]] ||= Hash(Int32, Char).new
      map[coord[:y]][coord[:x]] = val
      extend_bounds(coord)
    end

    # TODO can't get this to work. solution exits early
    def remove(coord, val)
      #draw
      map[coord[:y]] ||= Hash(Int32, Char).new
      #map[coord[:y]].delete(coord[:x])
      map[coord[:y]][coord[:x]] = val
      #draw
      extend_bounds(coord)
      #return unless map.has_key?(coord[:y])
      #return unless map[coord[:y]].has_key?(coord[:x])
      #map[coord[:y]].delete(coord[:x])
      #map.delete(coord[:y]) if map[coord[:y]].empty?
      #extend_bounds(coord)
    end

    def grid_coords_3x3(coord)
      [
        {x: -1, y: -1},
        {x: 0, y: -1},
        {x: 1, y: -1},
        {x: -1, y: 0},
        {x: 0, y: 0},
        {x: 1, y: 0},
        {x: -1, y: 1},
        {x: 0, y: 1},
        {x: 1, y: 1}
      ].map do |offset|
        {
          x: coord[:x] + offset[:x],
          y: coord[:y] + offset[:y]
        }
      end
    end
  end
end
