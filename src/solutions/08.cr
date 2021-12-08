class Aoc2021::Eight < Aoc2021::Solution
  def parse_input(file)
    File.read_lines(file).map do |line|
      signals, outputs = line.split('|')
      signals = signals.strip.split(' ')
      outputs = outputs.strip.split(' ')
      {
        signals: signals,
        outputs: outputs
      }
    end
  end

  def part1(lines)
    lines.sum do |line|
      line[:outputs].count do |output|
        output.size.in?(2,4,3,7)
      end
    end
  end

  def part2(lines)
    lines.sum do |line|
      decode_output(line[:signals], line[:outputs])
    end
  end

  DIGITS_SEGMENT_NUMS = {
    0 => [0,1,2,4,5,6],
    1 => [2,5],
    2 => [0,2,3,4,6],
    3 => [0,2,3,5,6],
    4 => [1,2,3,5],
    5 => [0,1,3,5,6],
    6 => [0,1,3,4,5,6],
    7 => [0,2,5],
    8 => [0,1,2,3,4,5,6],
    9 => [0,1,2,3,5,6]
  }

  private def decode_output(signals, outputs)

    # segment num to letter
    seg_map = Hash(Int32, Char).new

    displays = signals + outputs
    uniq = displays.map{ |d| d.chars.sort.join }.uniq

    one = uniq.find { |u| u.size == 2 }
    four = uniq.find { |u|  u.size == 4 }
    seven = uniq.find { |u|  u.size == 3 }
    eight = uniq.find { |u|  u.size == 7 }

    raise "did not find 1" if one.nil?
    raise "did not find 4" if four.nil?
    raise "did not find 7" if seven.nil?
    raise "did not find 8" if eight.nil?

    # segments 2 and 5 are in `ones`.
    # the number 6 uses every segment but 2, including segment 5.
    # there is no number that uses every segment but 5, including 2.
    six = uniq.find do |u| 
      u.size == 6 && (
        (u.includes?(one[0]) && !u.includes?(one[1])) ||
        (u.includes?(one[1]) && !u.includes?(one[0]))
      )
    end

    raise "did not find 6" if six.nil?

    if six.includes? one[0]
      seg_map[5] = one[0]
      seg_map[2] = one[1]
    else
      seg_map[5] = one[1]
      seg_map[2] = one[0]
    end

    seg_map[0] = seven.delete(seg_map[5]).delete(seg_map[2])[0]
    segs_1_2 = four.delete(seg_map[5]).delete(seg_map[2])

    # segment 1 appears 6 times; segment 3 appears 7 times.
    if uniq.count { |u|  u.includes?(segs_1_2[0]) } == 6
      seg_map[1] = segs_1_2[0]
      seg_map[3] = segs_1_2[1]
    else
      seg_map[1] = segs_1_2[1]
      seg_map[3] = segs_1_2[0]
    end

    zero = uniq.find do |u| 
      u.size == 6 && (
        (u.includes?(seg_map[1]) && !u.includes?(seg_map[2])) ||
        (u.includes?(seg_map[2]) && !u.includes?(seg_map[1]))
      )
    end
    raise "did not find 0" if zero.nil?

    three = uniq.find do |u| 
      u.size == 5 &&
        u.includes?(seg_map[0]) &&
        u.includes?(seg_map[2]) &&
        u.includes?(seg_map[3]) &&
        u.includes?(seg_map[5])
    end
    raise "did not find 3" if three.nil?
    seg_map[6] = three.delete(seg_map[0]).delete(seg_map[2]).delete(seg_map[3]).delete(seg_map[5])[0]
    seg_map[4] = ['a','b','c','d','e','f','g'].-(seg_map.values)[0]

    outputs.map do |o|
      segment_nums = o.chars.map { |c| seg_map.key_for(c) }.sort
      DIGITS_SEGMENT_NUMS.key_for(segment_nums)
    end.map(&.to_s).join.to_i32
  end
end
