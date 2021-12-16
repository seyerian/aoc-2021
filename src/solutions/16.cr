require "big"

class Aoc2021::Sixteen < Aoc2021::Solution
  alias Packet = NamedTuple(version: Int8, type_id: Int8, value: Int128, sub_packets: Array(Packet), length: Int128)

  HEX_MAP = {
    '0' => "0000",
    '1' => "0001",
    '2' => "0010",
    '3' => "0011",
    '4' => "0100",
    '5' => "0101",
    '6' => "0110",
    '7' => "0111",
    '8' => "1000",
    '9' => "1001",
    'A' => "1010",
    'B' => "1011",
    'C' => "1100",
    'D' => "1101",
    'E' => "1110",
    'F' => "1111"
  }

  def parse_input(file)
    line = File.read_lines(file)[0]
    #line.to_i128(16).to_s(2)
    bits = ""
    line.chars.each do |char|
      bits += HEX_MAP[char]
    end
    bits
  end

  def parse_packet(bin)
    version = bin[0..2].to_i8(2)
    type_id = bin[3..5].to_i8(2)
    value = 0_i128
    sub_packets = Array(Packet).new
    length = 0_i128
    case type_id
    when 4 # literal value
      num = ""
      i = 6
      loop do
        prefix = bin[i]
        group = bin[(i+1)..(i+4)]
        num += group
        i += 5
        break if prefix == '0'
      end
      length = i.to_i128
      value = num.to_i128(2)
    else # operator
      length_type_id = bin[6].to_i8(2)
      if length_type_id == 0
        packets_length = bin[7..21].to_i128(2)
        cursor = 22_i128
        cursor_max = cursor + packets_length
        until cursor >= cursor_max
          sub_packet = parse_packet(bin[cursor...cursor_max])
          cursor += sub_packet[:length]
          sub_packets << sub_packet
        end
        length = cursor
      elsif length_type_id == 1
        num_sub_packets = bin[7..17].to_i(2)
        remaining_packets = num_sub_packets 
        cursor = 18_i128
        cursor_max = bin.size
        until remaining_packets == 0 
          sub_packet = parse_packet(bin[cursor...cursor_max])
          cursor += sub_packet[:length]
          sub_packets << sub_packet
          remaining_packets -= 1
        end
        length = cursor
      else
        raise "invalid length type id"
      end
    end
    {
      version: version,
      type_id: type_id,
      value: value,
      sub_packets: sub_packets,
      length: length
    }
  end

  def version_sum(packet)
    sum = 0_i128
    sum += packet[:version]
    packet[:sub_packets].each do |subp|
      sum += version_sum(subp)
    end
    sum
  end

  def calc_packet(packet)
    subs = packet[:sub_packets]
    val = BigInt.new(0)
    case packet[:type_id]
    when 0
      subs.each do |subp|
        val += calc_packet(subp)
      end
    when 1
      factors = [] of BigInt
      subs.each do |subp|
        factors << calc_packet(subp)
      end
      val += factors.reduce(1) { |a, b| a * b }
    when 2
      val += subs.map do |subp|
        calc_packet(subp).as(BigInt)
      end.min
    when 3
      val += subs.map do |subp|
        calc_packet(subp).as(BigInt)
      end.max
    when 4
      val += packet[:value]
    when 5
      raise "ERROR" if subs.size > 2
      a = calc_packet(subs[0])
      b = calc_packet(subs[1])
      val += a > b ? 1 : 0
    when 6
      raise "ERROR" if subs.size > 2
      a = calc_packet(subs[0])
      b = calc_packet(subs[1])
      val += a < b ? 1 : 0
    when 7
      raise "ERROR" if subs.size > 2
      a = calc_packet(subs[0])
      b = calc_packet(subs[1])
      val += a == b ? 1 : 0
    end
    val
  end
  

  def part1(bin)
    packet = parse_packet(bin)
    version_sum(packet)
  end

  def part2(bin)
    packet = parse_packet(bin)
    calc_packet(packet)
  end
end
