class Aoc2021::Thirteen < Aoc2021::Solution
  alias Coord = NamedTuple(x: Int32, y: Int32)
  alias Fold = NamedTuple(axis: Symbol, num: Int32)

  class Transparency
    property dots
    property fold_instructions 

    def initialize(@dots : Array(Coord), @fold_instructions : Array(Fold))
    end

    def draw
      dots = @dots
      max_y = dots.map { |d| d[:y] }.max
      max_x = dots.map { |d| d[:x] }.max
      0.to(max_y) do |y|
        puts
        0.to(max_x) do |x|
          print dots.includes?({x: x, y: y}) ? '#' : '.'
        end
      end
    end

    def fold
      fold = @fold_instructions.shift
      dots = @dots
      a = fold[:axis]
      n = fold[:num]
      dots.each.with_index do |coord, i|
        b = a == :x ? :y : :x
        if coord[a] > n
          dots[i] = Coord.from({
            a => n - (coord[a] - n),
            b => coord[b]
          })
        end
      end
      @dots = dots.uniq
    end
  end

  def parse_input(file)
    groups = InputParsers.groups(file)
    coords = groups[0].map do |line|
      x, y = line.split(',')
      { x: x.to_i32, y: y.to_i32 }
    end
    folds = groups[1].map do |line|
      axis, num = line.split(' ')[-1].split('=')
      {
        axis: axis.chars.first == 'x' ? :x : :y,
        num: num.to_i32
      }
    end
    Transparency.new(dots: coords, fold_instructions: folds)
  end

  def part1(transparency)
    transparency.fold
    transparency.dots.size
  end

  def part2(transparency)
    until transparency.fold_instructions.size == 0
      transparency.fold 
    end
    transparency.draw
  end
end
