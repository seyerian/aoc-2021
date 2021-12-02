class Aoc2021::One < Aoc2021::Solution
  def parse_input(file)
    File.read_lines(file).map(&.to_i32)
  end

  def part1(input)
    input.each.cons_pair.count { |p| p[0] < p[1] }
  end

  def part2(input)
  end
end
