class Aoc2021::Nineteen < Aoc2021::Solution
  alias Triord = NamedTuple(x: Int32, y: Int32, z: Int32)
  # rotation is how to get beacon1 oriented in same was as beacon0
  alias BeaconMap = NamedTuple(beacon0: Triord, beacon1: Triord, rotation: Triord)
  alias BeaconMapList = Array(BeaconMap)
  # rotation is how to get scanner1 oriented in same was as scanner0
  # offset is what to add to scanner1 (rotated) to make it relative to scanner0
  # OR what to substract from scanner0 to make it relative to scanner1
  alias ScannerMap = NamedTuple(
    scanner0: Scanner, scanner1: Scanner,
    beacon_map_list: BeaconMapList,
    rotation: Triord,
    offset: Triord
  )
  alias ScannerMapList = Array(ScannerMap)
  alias Neighbor = NamedTuple(scanner: Scanner, rotation: Triord, offset: Triord) #, inverted: Bool)

  class Scanner
    getter id : Int32
    getter beacons : Array(Triord)
    property distances : Array(NamedTuple(distance: Int32, beacons: Array(Triord)))
    property neighbors : Array(Neighbor)

    def initialize(@id, @beacons)
      @distances = Array(NamedTuple(distance: Int32, beacons: Array(Triord))).new
      construct_distances
      @neighbors = [] of Neighbor
    end

    def construct_distances
      beacons.each_permutation(2) do |comb|
        a, b = comb
        dist = begin #Math.sqrt(
          (a[:x] - b[:x]) ** 2 +
          (a[:y] - b[:y]) ** 2 +
          (a[:z] - b[:z]) ** 2
        #)
               end
        distances << {
          distance: dist, #.round,
          beacons: [a,b]
        }
      end
    end
  end

  def map_beacons(scanner0, scanner1)
    beacon_map_list = BeaconMapList.new
    scanner0.distances.each do |d0|
      dist0 = d0[:distance]
      poss0 = d0[:beacons]
      #debug "s0 #{dist0}, #{poss0}"
      a0 = poss0[0]
      b0 = poss0[1]
      found_rotation = false
      scanner1.distances.each do |d1|
        dist1 = d1[:distance]
        poss1 = d1[:beacons]
        next unless dist0 == dist1
        next if found_rotation
        #debug "s1 #{dist1}, #{poss1}"
        #debug ""
        a1 = poss1[0]
        b1 = poss1[1]
        (0..3).each do |x|
          next if found_rotation
          (0..3).each do |y|
            next if found_rotation
            (0..3).each do |z|
              next if found_rotation
              rotation = {x: x, y: y, z: z}
              a1r = rotate(a1, rotation)
              b1r = rotate(b1, rotation)
              if diff(a0, a1r) == diff(b0, b1r)
                found_rotation = true
                beacon_map_list << {
                  beacon0: a0,
                  beacon1: a1,
                  rotation: rotation
                }
                #beacon_map_list << {
                #  beacon0: b0,
                #  beacon1: b1,
                #  rotation: rotation
                #}
                #debug "found rotation #{x},#{y},#{z}"
                #debug "a", a0, a1r, "b", b0, b1r
              end
            end
          end
        end
      end
    end
    beacon_map_list.uniq!
    return beacon_map_list if beacon_map_list.size == 0
    rotation_counts = beacon_map_list.group_by { |map|
      map[:rotation]
    }.map { |rotation, beacon_map_list|
      {
        rotation: rotation,
        count: beacon_map_list.size
      }
    }.sort_by { |t| t[:count] }.reverse
    #debug rotation_counts
    correct_rotation = rotation_counts.first[:rotation]
    beacon_map_list.select! do |beacon_map|
      beacon_map[:rotation] == correct_rotation
    end
    beacon_map_list
  end

  def rotate(pos : Triord, rot : Triord)
    p = pos
    p = rotate_x(p, rot[:x])
    p = rotate_y(p, rot[:y])
    p = rotate_z(p, rot[:z])
    p
  end

  def invert_rotation(rot : Triord)
    {
      x: 4 - rot[:x],
      y: 4 - rot[:y],
      z: 4 - rot[:z]
    }
  end

  def rotate_x(pos : Triord, turns = 0)
    until turns >= 0
      turns += 4
    end
    until turns < 4
      turns -= 4
    end
    case turns
    when 0 then pos
    when 1 then { y: pos[:z], x: pos[:x], z: -1 * pos[:y] }
    when 2 then { y: -1 * pos[:y], x: pos[:x], z: -1 * pos[:z] }
    when 3 then { y: -1 * pos[:z], x: pos[:x], z: pos[:y] }
    else raise "nil"
    end
  end

  def rotate_y(pos : Triord, turns = 0)
    until turns >= 0 && turns < 4
      turns -= 4
    end
    case turns
    when 0 then pos
    when 1 then { x: pos[:z], y: pos[:y], z: -1 * pos[:x] }
    when 2 then { x: -1 * pos[:x], y: pos[:y], z: -1 * pos[:z] }
    when 3 then { x: -1 * pos[:z], y: pos[:y], z: pos[:x] }
    else raise "nil"
    end
  end

  def rotate_z(pos : Triord, turns = 0)
    until turns >= 0 && turns < 4
      turns -= 4
    end
    case turns
    when 0 then pos
    when 1 then { x: pos[:y], z: pos[:z], y: -1 * pos[:x] }
    when 2 then { x: -1 * pos[:x], z: pos[:z], y: -1 * pos[:y] }
    when 3 then { x: -1 * pos[:y], z: pos[:z], y: pos[:x] }
    else raise "nil"
    end
  end

  def parse_input(file)
    groups = InputParsers.groups(file)
    groups.map do |group|
      Scanner.new(
        id: group.shift.split(' ')[2].to_i32,
        beacons: group.map { |l|
          xyz = l.split(',')
          {
            x: xyz[0].to_i32,
            y: xyz[1].to_i32,
            z: xyz[2].to_i32
          }
        }
      )
    end
  end

  # TO, FROM
  def diff(pos0 : Triord, pos1 : Triord)
    {
      x: pos0[:x] - pos1[:x],
      y: pos0[:y] - pos1[:y],
      z: pos0[:z] - pos1[:z]
    }
  end

  def map_scanners(scanners)
    scanner_map_list = ScannerMapList.new
    scanners.each_permutation(2) do |pair|
      s0, s1 = pair
      beacon_map_list = map_beacons(s0, s1)
      #if s0.id == 22
      #  if beacon_map_list.size >= 12
      #    debug "#{beacon_map_list.size} common with #{s1.id}"
      #  end
      #end
      if beacon_map_list.size >= 12
        bm0 = beacon_map_list[0]
        rotation = bm0[:rotation]
        b1_rotated = rotate(bm0[:beacon1], rotation)
        offset = diff(bm0[:beacon0], b1_rotated)
        scanner_map_list << {
          scanner0: s0,
          scanner1: s1,
          beacon_map_list: beacon_map_list,
          rotation: rotation,
          offset: offset
        }
      end
    end
    scanner_map_list
  end

  def path(scanner, target, original_scanner, existing_path = [] of Neighbor)
    path_scanners = existing_path.map { |n| n[:scanner] }
    scanner.neighbors.each do |neighbor|
      next if neighbor[:scanner] == scanner
      # next if neighbor[:scanner] == original_scanner # NOTE this changes answer but should not. should only increase speed.
      next if path_scanners.includes?(neighbor[:scanner])
      new_path = existing_path.dup
      new_path << neighbor
      if neighbor[:scanner] == target
        return new_path
      else
        path = path(neighbor[:scanner], target, original_scanner, new_path)
        unless path.nil?
          return path
        end
      end
    end
  end

  def network_scanners(scanners)
    scanner_map_list = map_scanners(scanners)
    #scanner_map_list.each do |sm|
      #debug "#{sm[:scanner1].id} -> #{sm[:scanner0].id}"
    #end
    scanner_map_list.each do |scanner_map|
      s0 = scanner_map[:scanner0]
      s1 = scanner_map[:scanner1]
      s1.neighbors << {
        scanner: s0,
        rotation: scanner_map[:rotation],
        offset: scanner_map[:offset],
      }
    end
  end

  def get_all_beacons(scanners)
    network_scanners(scanners)
    scanner_map_list = map_scanners(scanners)
    #scanner_map_list.each do |sm|
    #  debug "#{sm[:scanner1].id} -> #{sm[:scanner0].id}"
    #end
    scanner_map_list.each do |scanner_map|
      s0 = scanner_map[:scanner0]
      s1 = scanner_map[:scanner1]
      s1.neighbors << {
        scanner: s0,
        rotation: scanner_map[:rotation],
        offset: scanner_map[:offset],
      }
    end

    all_beacons = [] of Triord

    s0 = scanners.shift
    s0.beacons.each do |beacon|
      all_beacons << beacon
    end

    scanners.each do |scanner|
      path = path(scanner, s0, scanner)
      raise "no path from ##{scanner.id} to ##{s0.id}" if path.nil?

      scanner.beacons.each do |beacon|
        transformed = beacon
        path.each do |neighbor|
          transformed = rotate(transformed, neighbor[:rotation])
          transformed = {
            x: transformed[:x] + neighbor[:offset][:x],
            y: transformed[:y] + neighbor[:offset][:y],
            z: transformed[:z] + neighbor[:offset][:z],
          }
        end
        all_beacons << transformed
      end
      all_beacons.uniq!
    end

    all_beacons.uniq!
    all_beacons.sort_by! do |b|
      [b[:x], b[:y], b[:z]]
    end
    all_beacons
  end

  def part1(scanners)
    get_all_beacons(scanners).size
  end

  def part2(scanners)
    network_scanners(scanners)

    scanner_positions = [] of Triord

    # s0
    s0 = scanners.shift
    scanner_positions << {x: 0, y: 0, z: 0}

    scanners.each do |scanner|
      path = path(scanner, s0, scanner)
      raise "no path from ##{scanner.id} to ##{s0.id}" if path.nil?

      origin = {x: 0, y: 0, z: 0}
      path.each do |neighbor|
        origin = rotate(origin, neighbor[:rotation])
        origin = {
          x: origin[:x] + neighbor[:offset][:x],
          y: origin[:y] + neighbor[:offset][:y],
          z: origin[:z] + neighbor[:offset][:z],
        }
      end
      scanner_positions << origin
    end

    largest_dist = 0
    scanner_positions.each_combination(2) do |pair|
      s0, s1 = pair
      dist = 
        (s0[:x] - s1[:x]).abs +
        (s0[:y] - s1[:y]).abs +
        (s0[:z] - s1[:z]).abs
      largest_dist = dist if dist > largest_dist
    end
    largest_dist
  end
end
