class Aoc2021::Eleven < Aoc2021::Solution
  alias Coord = NamedTuple(x: Int32, y: Int32)

  class Octopuses
    property flashes, map : Array(Array(Int32))
    property min_x : Int32,
             max_x : Int32,
             min_y : Int32,
             max_y : Int32
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
      @flashes = Array(Array(Coord)).new
    end

    def draw
      row = -1
      each do |octo, coord|
        if row != coord[:y]
          puts "" 
          row = coord[:y]
        end
        print octo
      end
    end

    def each
      map.each.with_index do |row, y|
        row.each.with_index do |octo, x|
          yield octo, {x: x, y: y}
        end
      end
    end

    def get(coord)
      x = coord[:x]
      y = coord[:y]
      return if x < min_x || x > max_x
      return if y < min_y || y > max_y
      if (row = map[y]?)
        if (octo = row[x]?)
          return octo
        end
      end
    end

    def set(coord, val)
      if (existing = get(coord))
        map[coord[:y]][coord[:x]] = val
      end
    end

    def inc(coord)
      if (octo = get(coord))
        set(coord, octo + 1)
      end
    end
    
    def step
      flashes << [] of Coord
      each do |octo, coord|
        set(coord, octo + 1)
      end
      each do |octo, coord|
        flash(coord) if octo > 9
      end
      flashes.last.each do |coord|
        set(coord, 0)
      end
    end

    def flash(coord)
      return if flashes.last.includes?(coord)
      flashes.last << coord
      [
        {x: 1, y: 0},
        {x: 0, y: 1},
        {x: -1, y: 0},
        {x: 0, y: -1},
        {x: 1, y: 1},
        {x: 1, y: -1},
        {x: -1, y: 1},
        {x: -1, y: -1},
      ].each do |offset|
        adj = {
          x: coord[:x] + offset[:x],
          y: coord[:y] + offset[:y]
        }
        inc(adj)
        if (val = get(adj))
          flash(adj) if val > 9
        end
      end
    end

    def last_flash_count
      flashes.last.size
    end

    def flash_count
      flashes.flatten.size
    end
  end

  def parse_input(file)
    Octopuses.new(InputParsers.map(file))
  end

  def part1(octos)
    100.times do |i|
      octos.step
    end
    octos.flash_count
  end

  def part2(octos)
    last = 0
    loop do
      last = last + 1
      octos.step
      break if octos.last_flash_count == 100
    end
    last
  end
end
