alias Int32Nest = Int32 | Array(Int32Nest)
class Aoc2021::Eighteen < Aoc2021::Solution
  DIGIT_CHARS = [ '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' ]

  def parse_input(file)
    lines = File.read_lines(file)
    lines.map { |l| parse_arr(l) }
  end

  def parse_arr(str : String)
    arr = [] of Int32Nest
    str = str[1, str.size - 2]
    cursor = 0
    until cursor >= str.size
      char = str[cursor]
      case 
      when char == '['
        arr_str = "["
        opens = 1
        closes = 0
        until closes == opens
          cursor += 1
          next_char = str[cursor]
          arr_str += next_char
          opens += 1 if next_char == '['
          closes += 1 if next_char == ']'
        end
        arr << parse_arr(arr_str)
      when DIGIT_CHARS.includes?(char)
        num = "#{char}"

        loop do
          break if cursor + 1 >= str.size
          next_char = str[cursor + 1]
          break unless next_char.in?(DIGIT_CHARS)
          cursor += 1
          num += next_char
        end

        arr << num.to_i32
      when char == ','
        #
      when char == ']'
        raise "found ]" # all closing bracks should be popped
      end
      cursor += 1
    end

    arr
  end

  def add(a : Int32Nest, b : Int32Nest)
    arr = [] of Int32Nest
    arr << a
    arr << b
    #debug "=> #{arr}"
    arr
  end

  def max_depth(el : Int32Nest, depth = 0)
    return depth if el.is_a?(Int32)
    el.map { |e| max_depth(e, depth + 1) }.max
  end

  def greatest(el : Int32Nest, greatest = 0)
    #debug_i "greatest of #{el}?"
    return el if el.is_a?(Int32)
    max = el.map { |e| greatest(e, greatest) }.max
    #debug_i "greatest of #{el} is #{max}"
    max
  end

  def explode_left(el : Int32Nest, val : Int32, i = 0)
    #debug_i "#explode_left(#{el},#{val},#{i})"
    raise "explode_left > 10" if i > 10
    if el.is_a?(Int32)
      el + val
    else # Array
      a = el[0]
      b = el[1]
      raise "nil in #explode_right" if a.nil? || b.nil?
      arr = [] of Int32Nest
      arr << a
      arr << explode_left(b, val, i + 1)
      arr
    end
  end

  def explode_right(el : Int32Nest, val : Int32, i = 0)
    #debug_i "#explode_right(#{el},#{val},#{i})"
    raise "explode_right > 10" if i > 10
    if el.is_a?(Int32)
      el + val
    else # Array
      a = el[0]
      b = el[1]
      raise "nil in #explode_right" if a.nil? || b.nil?
      arr = [] of Int32Nest
      arr << explode_right(a, val, i + 1)
      arr << b
      arr
    end
  end

  def try_explode(el : Int32Nest, depth = 1)
    #debug_i "#try_explode #{el}, depth #{depth}"
    did_explode = false
    exploded_at = -1
    do_explode_left = false
    do_explode_right = false
    explode_left_val = 0
    explode_right_val = 0

    values = [] of Int32Nest

    if depth > 4 && el.all? { |n| n.is_a?(Int32) } && !did_explode
      #debug_i "exploding #{el}"
      did_explode = true
      do_explode_left = true
      do_explode_right = true
      explode_left_val = el[0].as(Int32)
      explode_right_val = el[1].as(Int32)
      values = 0
    else
      el.each.with_index do |e, i|
        val =
          if e.is_a?(Array)
            if do_explode_right
              do_explode_right = false
              explode_right(e, explode_right_val)
            elsif !did_explode
              explosion = try_explode(e, depth + 1)
              did_explode = explosion[:did_explode]
              exploded_at = i if (did_explode)
              do_explode_left = explosion[:do_explode_left]
              do_explode_right = explosion[:do_explode_right]
              explode_left_val = explosion[:explode_left_val]
              explode_right_val = explosion[:explode_right_val]
              #debug "exploded with values #{explosion[:values]}"
              explosion[:values]
            else
              e
            end
          else # Int32
            if do_explode_right
              do_explode_right = false
              explode_right(e, explode_right_val)
            else
              e
            end
          end

        if do_explode_left && i > 0 && i-1 != exploded_at
          #debug_i "do explode left #{explode_left_val} #{i}-1=#{i-1} (#{values})"
          values[i-1] = explode_left(values[i-1], explode_left_val)
          do_explode_left = false
        end
        
        values << val
      end
    end

    {
      did_explode: did_explode,
      do_explode_left: do_explode_left,
      do_explode_right: do_explode_right,
      explode_left_val: explode_left_val,
      explode_right_val: explode_right_val,
      values: values
    }
  end

  def try_split(el : Int32Nest, did_split = false)
    return { values: el, did_split: true } if did_split
    #debug_i "#try_split #{el}"

    raise "can't splint Int32" if el.is_a?(Int32)

    values = el.map do |e|
      val = 
        if e.is_a?(Int32)
          if e >= 10 && !did_split
            did_split = true
            e_arr = [] of Int32Nest
            e_arr << (e / 2).floor.to_i32
            e_arr << (e / 2).ceil.to_i32
            #debug_i "did split #{e} to #{e_arr}"
            e_arr
          else
            e
          end
        else # Arr
          splitted = try_split(e, did_split)
          did_split = splitted[:did_split]
          splitted[:values]
        end
      val.as(Int32Nest)
    end

    {
      did_split: did_split,
      values: values
    }
  end

  def reduce(a, explode_limit = -1)
    #debug_i "#reduce(#{a})"
    reduced = false
    until reduced
      max_depth_of_a = max_depth(a)
      if max_depth_of_a > 4
        #debug "#max_depth > 4 (#{max_depth_of_a})"
        raise "unexpected Int32 in #reduce" if a.is_a?(Int32)
        #debug_i "#reduce try_explode(#{a})"
        exploded = try_explode(a)
        #debug "exploded to #{exploded[:values]}", ""
        explode_limit -= 1
        a = exploded[:values]
        break if explode_limit == 0
      elsif greatest(a) >= 10
        splitted = try_split(a)
        #debug "splitted to #{splitted[:values]}", ""
        a = splitted[:values]
      else
        reduced = true
      end
    end
    a
  end

  def magnitude(el : Int32Nest)
    if el.is_a?(Int32)
      el
    else
      3 * magnitude(el[0]) + 2 * magnitude(el[1])
    end
  end

  def test
    #debug reduce(parse_arr("[[[[[9,8],1],2],3],4]"))
    #debug reduce(parse_arr("[7,[6,[5,[4,[3,2]]]]]"))
    #debug reduce(parse_arr("[[6,[5,[4,[3,2]]]],1]"))
    #debug reduce(parse_arr("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]"), explode_limit: 1)
    #debug reduce(parse_arr("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"), explode_limit: 1)
  end

  def part1(numbers)
    total = numbers.reduce do |sum, n|
      #debug_i "#{sum} + #{n}"
      v = reduce(add(sum, n))
      #debug_i "= #{v}"
      v
    end
    #debug_i total
    magnitude(total)
  end

  def part2(numbers)
    highest_mag = 0
    numbers.each_permutation(2) do |pair|
      a, b = pair
      sum = reduce(add(a, b))
      mag = magnitude(sum)
      #debug a, b
      #debug sum
      #debug mag
      #debug_i ""
      if mag > highest_mag
        highest_mag = mag
      end
    end
    highest_mag
  end
end
