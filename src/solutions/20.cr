class Aoc2021::Twenty < Aoc2021::Solution
  def parse_input(file)
    groups = InputParsers.groups(file)
    {
      enhancement_algo: groups[0][0],
      input_image: Map.new(groups[1].map(&.chars)),
    }
  end

  def count_lit(image)
    lit = 0
    image.each do |val, coord|
      lit += 1 if val == '#'
    end
    lit
  end

  def enhance(algo, image, odd : Bool)
    enhanced = Map.new
    default = !odd && algo[0] == '#' ? '#' : '.'
    ((image.min_y - 1)..(image.max_y + 1)).each do |y|
      ((image.min_x - 1)..(image.max_x + 1)).each do |x|
        str = ""
        image.grid_coords_3x3({x: x, y: y}).each do |coord|
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
    count_lit(image)
  end

  def part2(input)
    enhancer = input[:enhancement_algo]
    image = input[:input_image]
    50.times do |i|
      image = enhance(enhancer, image, odd: i.even?)
    end
    count_lit(image)
  end
end
