class Aoc2021::Three < Aoc2021::Solution
  def parse_input(file)
    File.read_lines(file).map(&.chars)
  end

  def part1(input)
    len = input.first.size
    gamma = len.times.map { |i| common(input, i) }.join
    epsilon = len.times.map { |i| uncommon(input, i) }.join
    gamma.to_i32(2) * epsilon.to_i32(2)
  end

  def part2(input)
    len = input.first.size
    numbers = input.dup
    numbers2 = input.dup
    len.times do |i|
      c = common(numbers, i)
      numbers.select! { |n| n[i] == c }
      break if numbers.size == 1
    end
    len.times do |i|
      u = uncommon(numbers2, i)
      numbers2.select! { |n| n[i] == u }
      break if numbers2.size == 1
    end
    o = numbers[0].join
    co2 = numbers2[0].join
    o.to_i32(2) * co2.to_i32(2)
  end
  
  private def common(numbers, i)
    tally = numbers.tally_by { |n| n[i] }
    tally['1'] >= tally['0'] ? '1' : '0'
  end

  private def uncommon(numbers, i)
    tally = numbers.tally_by { |n| n[i] }
    tally['0'] <= tally['1'] ? '0' : '1'
  end
end
