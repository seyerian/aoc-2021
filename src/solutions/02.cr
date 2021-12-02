class Aoc2021::Two < Aoc2021::Solution
  def parse_input(file)
    File.read_lines(file)
  end

  def part1(input)
    d = 0
    x = 0
    input.each do |s|
      s = s.split(" ")
      dir = s[0]
      n = s[1].to_i32
      case dir
      when "forward"
        x += n
      when "down"
        d += n
      when "up"
        d -= n
      end
    end
    d * x
  end

  def part2(input)
    a = 0
    d = 0
    x = 0
    input.each do |s|
      s = s.split(" ")
      dir = s[0]
      n = s[1].to_i32
      case dir
      when "forward"
        x += n
        d += a * n
      when "down"
        a += n
      when "up"
        a -= n
      end
    end
    d * x
  end
end
