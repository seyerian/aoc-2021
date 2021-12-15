module Aoc2021
  alias Coord = NamedTuple(x: Int32, y: Int32)

  class Map
    def_clone

    property map : Array(Array(Int32))
    property min_x : Int32,
      max_x : Int32,
      min_y : Int32,
      max_y : Int32

    property width : Int32,
             height : Int32

    def initialize(@width : Int32, @height : Int32, fill = -1)
      @map = Array(Array(Int32)).new(@height)
      @height.times do
        @map << Array(Int32).new(@width, fill)
      end
      @min_y = 0
      @max_y = @map.size - 1
      @min_x = 0 
      @max_x = @map[0].size - 1
    end

    def initialize(map : Array(Array(Char)))
      @map = Array(Array(Int32)).new
      map.each.with_index do |row, y|
        int_row = Array(Int32).new
        @map << int_row
        row.each.with_index do |char, x|
          int_row << char.to_i32
        end
      end
      @min_y = 0
      @max_y = @map.size - 1
      @min_x = 0 
      @max_x = @map[0].size - 1
      @height = @max_y + 1
      @width = @max_x + 1
    end

    def draw
      row = -1
      each do |val, coord|
        if row != coord[:y]
          puts "" 
          row = coord[:y]
        end
        print val
      end
    end

    def each
      map.each.with_index do |row, y|
        row.each.with_index do |val, x|
          yield val, {x: x, y: y}
        end
      end
    end

    def get(coord)
      x = coord[:x]
      y = coord[:y]
      return if x < min_x || x > max_x
      return if y < min_y || y > max_y
      if (row = map[y]?)
        if (val = row[x]?)
          return val
        end
      end
    end

    def set(coord, val)
      map[coord[:y]] ||= Array(Int32).new(width)
      #if (existing = get(coord))
      map[coord[:y]][coord[:x]] = val
      #end
    end

    def inc(coord)
      if (val = get(coord))
        set(coord, val + 1)
      end
    end

    def neighbors(coord, diagonal = true)
      offsets = [
        {x: 1, y: 0},
        {x: 0, y: 1},
        {x: -1, y: 0},
        {x: 0, y: -1},
      ]
      if diagonal
        offsets.concat([
          {x: 1, y: 1},
          {x: 1, y: -1},
          {x: -1, y: 1},
          {x: -1, y: -1},
        ])
      end
      offsets.map do |offset|
        {
          x: coord[:x] + offset[:x],
          y: coord[:y] + offset[:y]
        }
      end
    end
  end
end
