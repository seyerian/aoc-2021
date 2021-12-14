class Aoc2021::Fourteen < Aoc2021::Solution
  def parse_input(file)
    groups = InputParsers.groups(file)
    template = groups[0][0]

    rules = Hash(String, Char).new

    groups[1].each do |line|
      pair, replacement = line.split(" -> ")
      rules[pair] = replacement.chars[0]
    end

    {
      template: template,
      rules: rules
    }
  end

  def step(str, rules)
    # find insertion points
    insertions = Hash(Int32, Char).new

    pairs = rules.keys
    pairs_used = Array(String).new
    pair_counts = Hash(String, Int32).new

    rules.each do |pair, char|
      cursor = -1
      while (cursor = str.index(pair, cursor + 1))
        if !pairs_used.includes?(pair) 
          pairs_used << pair 
          pair_counts[pair] = 1
        else
          pair_counts[pair] += 1
        end
        # insertion point is AFTER the first char in pair
        insertions[cursor + 1] = char
      end
    end

    # make insertions
    insertions.keys.sort.each.with_index do |cursor, i|
      curs = cursor + i
      c = insertions[cursor]
      str = str.insert(curs, c)
    end

    str
  end

  def count(str)
    elements = str.chars.uniq
    counts = elements.map do |el|
      count = str.count(el)
      {
        el: el,
        count: count,
        perc: count / str.size.to_f
      }
    end
  end

  def part1(input)
    str = input[:template]
    rules = input[:rules]

    10.times do |i|
      str = step(str, rules)
    end

    counts = count(str)
    max = counts.max_by { |count| count[:count] }
    min = counts.min_by { |count| count[:count] }
    max[:count] - min[:count]
  end

  def part2(input)
    str = input[:template]
    rules = input[:rules]

    pair_counter = Hash(String, Int64).new(0_i64)
    cur_pair_counter = pair_counter.dup

    str.chars.each_cons_pair do |c1, c2|
      cur_pair_counter["#{c1}#{c2}"] += 1
    end

    40.times do |i|
      new_pair_counter = pair_counter.dup
      cur_pair_counter.each do |pair, count|
        char = rules[pair]
        new_pair_1 = "#{pair[0]}#{char}"
        new_pair_2 = "#{char}#{pair[1]}"
        new_pair_counter[new_pair_1] += count
        new_pair_counter[new_pair_2] += count
      end
      cur_pair_counter = new_pair_counter
    end

    char_counter = Hash(Char, Int64).new(0_i64)
    cur_pair_counter.each do |pair, count|
      char_counter[pair[0]] += count
      char_counter[pair[1]] += count
    end
    char_counter[str[0]] += 1
    char_counter[str[-1]] += 1
    char_counter = char_counter.transform_values { |count| count // 2 }
    char_counter.values.max - char_counter.values.min
  end
end
