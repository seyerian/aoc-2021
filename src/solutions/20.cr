class Aoc2021::Twenty < Aoc2021::Solution
  class Image
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

    def extend_bounds(coord)
      y_a = [coord[:y], min_y, max_y]
      x_a = [coord[:x], min_x, max_x]
      @min_y = y_a.min
      @max_y = y_a.max
      @min_x = x_a.min
      @max_x = x_a.max
    end

    def draw
      (min_y..max_y).each do |y|
        puts
        (min_x..max_x).each do |x|
          print get({x: x, y: y})
        end
      end
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

    def grid_coords(coord)
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

    def count_lit
      lit = 0
      each do |val, coord|
        lit += 1 if val == '#'
      end
      lit
    end
  end

  def parse_input(file)
    groups = InputParsers.groups(file)
    {
      enhancement_algo: groups[0][0],
      input_image: Image.new(groups[1].map(&.chars)),
    }
  end

  def enhance(algo, image, odd : Bool)
    enhanced = Image.new
    default = !odd && algo[0] == '#' ? '#' : '.'
    ((image.min_y - 1)..(image.max_y + 1)).each do |y|
      ((image.min_x - 1)..(image.max_x + 1)).each do |x|
        str = ""
        image.grid_coords({x: x, y: y}).each do |coord|
          str += image.get(coord, default) == '#' ? "1" : "0"
        end
        enhanced.set(
          {x: x, y: y},
          algo.char_at(str.to_i32(2))
        )
      end
    end
    enhanced
  end

  def part1(input)
    enhancer = input[:enhancement_algo]
    image = input[:input_image]
    2.times do |i|
      image = enhance(enhancer, image, odd: i.even?)
    end
    image.count_lit
  end

  def part2(input)
    enhancer = input[:enhancement_algo]
    image = input[:input_image]
    50.times do |i|
      image = enhance(enhancer, image, odd: i.even?)
    end
    image.count_lit
  end
end
