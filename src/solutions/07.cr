class Aoc2021::Seven < Aoc2021::Solution
  def parse_input(file)
    File.read_lines(file).first.split(',').map(&.to_i32)
  end

  def part1(crabs)
    (crabs.min..crabs.max).map do |x|
      crabs.sum { |c| (c - x).abs }
    end.min
  end

  def part2(crabs)
    (crabs.min..crabs.max).map do |x|
      crabs.sum { |c| (1..(c - x).abs).sum }
    end.min
  end
end
