class Aoc2021::Five < Aoc2021::Solution
  class HtVent
    getter x1, y1, x2, y2
    getter min_x : Int32, max_x : Int32, min_y : Int32, max_y : Int32
    getter m : Float64, b : Float64 # y = mx + b for diagonals

    def initialize(@x1 : Int32, @y1 : Int32, @x2 : Int32, @y2 : Int32)
      @min_x = [@x1, @x2].min
      @max_x = [@x1, @x2].max
      @min_y = [@y1, @y2].min
      @max_y = [@y1, @y2].max
      # y = mx + b
      @m = (@y2 - @y1) / (@x2 - @x1)
      @b = @y1 - @m * @x1
    end

    def diagonal?
      !(x1 == x2 || y1 == y2)
    end
    def horizontal?; y1 == y2; end
    def vertical?; x1 == x2; end

    def covers?(x : Int32, y : Int32)
      if diagonal?
        (y == m * x + b) && y_bound?(y) && x_bound?(x)
      elsif horizontal?
        y1 == y && x_bound?(x)
      elsif vertical?
        x1 == x && y_bound?(y)
      end
    end

    private def x_bound?(x : Int32)
      x >= min_x && x <= max_x
    end
    private def y_bound?(y : Int32)
      y >= min_y && y <= max_y
    end
  end
  
  def parse_input(file)
    InputParsers.pattern(file, /(\d+),(\d+) -> (\d+),(\d+)/) do |m|
      HtVent.new(
        x1: m[1].to_i32,
        y1: m[2].to_i32,
        x2: m[3].to_i32,
        y2: m[4].to_i32
      )
    end
  end

  def part1(vents)
    count_overlaps(vents, diagonal: false)
  end

  def part2(vents)
    count_overlaps(vents, diagonal: true)
  end

  def count_overlaps(vents, diagonal = false)
    max_x = vents.map(&.x1).+(vents.map(&.x2)).max
    max_y = vents.map(&.y1).+(vents.map(&.y2)).max

    floor = Array(Array(Int32)).new(
      max_y + 1,
      Array(Int32).new(
        max_x + 1,
        0
      )
    )

    overlaps = [] of Int32

    (0..max_y).each do |y|
      (0..max_x).each do |x|
        count = vents.count do |vent|
          # part1 doesn't consider diagonal lines
          next if vent.diagonal? && !diagonal 
          vent.covers?(x,y)
        end
        overlaps << count if count > 1
        floor[y][x] = count
      end
    end

    overlaps.size
  end
end
