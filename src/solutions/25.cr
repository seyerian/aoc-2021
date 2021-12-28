require "../helpers/map"

class Aoc2021::TwentyFive < Aoc2021::Solution
  def parse_input(file)
    Map.new(InputParsers.map(file))
  end

  def move_east(map)
    map2 = map.clone
    map.each do |char, coord|
      next unless char == '>'
      right_coord = {x: coord[:x] + 1, y: coord[:y]}
      right_coord = {x: map.min_x, y: coord[:y]} if right_coord[:x] > map.max_x
      right_char = map.get(right_coord)
      if right_char == '.'
        map2.set(coord, '.')
        map2.set(right_coord, '>')
      end
    end
    map2
  end

  def move_south(map)
    map2 = map.clone
    map.each do |char, coord|
      next unless char == 'v'
      down_coord = {x: coord[:x], y: coord[:y] + 1}
      down_coord = {x: coord[:x], y: map.min_y} if down_coord[:y] > map.max_y
      down_char = map.get(down_coord)
      if down_char == '.'
        map2.set(coord, '.')
        map2.set(down_coord, 'v')
      end
    end
    map2
  end

  def step(map)
    map = move_east(map)
    map = move_south(map)
  end

  def part1(map)
    i = 0
    #debug ""
    #map.draw
    #sleep 0.1
    loop do
      i += 1
      map_prev = map.clone
      map = step(map)
      #debug ""
      #map.draw
      #sleep 0.1
      break if map_prev == map
    end
    i
  end

  def part2(map)
  end
end
