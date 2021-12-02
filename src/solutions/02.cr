class Aoc2021::Two < Aoc2021::Solution
  def parse_input(file)
    InputParsers.pattern(file, /\A(\w+) (\d+)\z/) do |m|
      {
        dir: m[1],
        mag: m[2].to_i32
      }
    end
  end

  def part1(input)
    d = x = 0
    input.each do |i|
      case i[:dir]
      when "forward"
        x += i[:mag]
      when "down"
        d += i[:mag]
      when "up"
        d -= i[:mag]
      end
    end
    d * x
  end

  def part2(input)
    d = x = a = 0
    input.each do |i|
      case i[:dir]
      when "forward"
        x += i[:mag]
        d += a * i[:mag]
      when "down"
        a += i[:mag]
      when "up"
        a -= i[:mag]
      end
    end
    d * x
  end
end
