require "big"

class Aoc2021::TwentyThree < Aoc2021::Solution
  property step_queue : Array(Step)
  property step_queue_done_steps : Array(Step)
  property step_queue_all_steps : Hash(Map, Array(Step))

  def initialize
    @step_queue = [] of Step
    @step_queue_done_steps = [] of Step
    @step_queue_all_steps = Hash(Map, Array(Step)).new
    #@run_step = BigInt.new(0)
  end

  def parse_input(file)
    Map.new(File.read_lines(file).map(&.chars))
  end

  alias Coord = NamedTuple(x: Int32, y: Int32)
  alias Move = NamedTuple(from: Coord, to: Coord, amp: Char, energy: Int32, jump: Bool, lock: Bool, done: Bool)
  alias Moveset = Array(Move)

  alias Step = NamedTuple(
    map: Map,
    locks: Map,
    prev_map: Map | Nil,
    prev_locks: Map | Nil,
    correct_count: Int32,
    total_energy: Int32,
    energy: Int32
  )

  AX = 3
  BX = 5
  CX = 7
  DX = 9

  Y0 = 1
  Y1 = 2
  Y2 = 3
  Y3 = 4
  Y4 = 5

  A = 'A'
  B = 'B'
  C = 'C'
  D = 'D'

  WALL = '#'
  OPEN = '.'
  LOCKED = 'X'
  DONE = 'Z'
  AMPS = [A, B, C, D]
  NOT_WALL = [*AMPS, OPEN]

  ENERGY = { A => 1, B => 10, C => 100, D => 1000 }

  def dist(a,b)
    ax, ay = a[:x], a[:y] 
    bx, by = b[:x], b[:y] 
    d = 0
    until ay == 1
      d += 1
      ay -= 1
    end
    until by == 1
      d += 1
      by -= 1
    end
    (b[:x] - a[:x]).abs + d
  end

  def unwinnable?(map : Map, locks : Map)
    # if any two block each other
    map.each do |char, coord|
      next unless AMPS.includes?(char)
      next unless in_hallway?(coord, map)
      next unless locks.get(coord, nil) == LOCKED
      map.each do |char2, coord2|
        next if coord == coord2
        next if char == char2
        next unless AMPS.includes?(char2)
        next unless in_hallway?(coord2, map)
        next unless locks.get(coord2, nil) == LOCKED
        c1_blocked = blocked_home_by?(char, coord, coord2, map)
        c2_blocked = blocked_home_by?(char2, coord2, coord, map)
        return true if c1_blocked && c2_blocked
      end
    end
    false
  end

  # unsophisticated check on min energy required for winning, w/out factoring in blocks.
  def min_win_energy(map)
    min_win_en = 0
    map.each do |char, coord|
      next unless AMPS.includes?(char)
      next if room_label(coord, map) == char

      to = 
        case char
        when A then {x: AX, y: Y1}
        when B then {x: BX, y: Y1}
        when C then {x: CX, y: Y1}
        when D then {x: DX, y: Y1}
        else raise "#min_win_energy char has no home"
        end
      min_win_en += dist(to, coord)
    end
    min_win_en
  end

  def spot_in_room(amp, map)
    x =
      case amp
      when A then AX
      when B then BX
      when C then CX
      when D then DX
      else
        raise "invalid amp in #spot_in_room"
      end

    spots = [
      {x: x, y: Y1},
      {x: x, y: Y2}
    ]

    if expanded_map?(map)
      spots << {x: x, y: Y3}
      spots << {x: x, y: Y4}
    end
    
    spots.reverse.each do |spot|
      char = map.get(spot)
      next if char == amp
      return if AMPS.includes?(char)
      return spot
    end
  end

  def mark_done(map : Map, locks : Map)
    locks = locks.clone
    map.each do |char, coord|
      next unless AMPS.includes?(char)
      next if [DONE, LOCKED].includes?(locks.get(coord, nil))
      next unless room_label(coord, map) == char

      expanded = expanded_map?(map)

      below = {x: coord[:x], y: coord[:y] + 1}

      if map.get(below) == WALL || locks.get(below) == DONE
        locks.set(coord, DONE)
      end
    end
    locks
  end

  def potential_moves(map : Map, locks : Map)
    moves_to_room = [] of Move
    moves = [] of Move
    map.each do |char, coord|
      next unless AMPS.includes?(char)
      next if locks.get(coord, nil) == DONE

      room_spot = spot_in_room(char, map)

      if !room_spot.nil? && open_path?(coord, room_spot, map, coord)
        steps = dist(room_spot, coord)
        energy = ENERGY[char] * steps
        # force this move next
        move = { from: coord, to: room_spot, amp: char, energy: energy, jump: true, lock: false, done: true }
        moves << move
        moves_to_room << move
        #m = map.clone
        #m.set(room_spot, '!')
        #m.draw
        #debug "forcing move home"
        break 
      end

      next if locks.get(coord, nil) == LOCKED || moves_to_room.any?

      #[ {x: 1, y: 0}, {x: -1, y: 0}, {x: 0, y: 1}, {x: 0, y: -1} ].each do |o|
      #coord2 = {x: coord[:x] + o[:x], y: coord[:y] + o[:y]}
      map.each do |char2, coord2|
        next unless char2 == OPEN
        next unless in_hallway?(coord2, map)
        next if at_door?(coord2, map)
        room = room_label(coord2, map) 
        next if in_room?(coord2, map)
        next unless open_path?(coord, coord2, map, coord)
        steps = dist(coord, coord2)
        moves << { from: coord, to: coord2, amp: char, energy: ENERGY[char] * steps, jump: true, lock: true, done: false }
      end
    end

    if moves_to_room.any?
      moves_to_room
    else
      moves
    end
  end

  def in_room?(coord, map)
    coord[:y] > 1 && [AX, BX, CX, DX].includes?(coord[:x]) && map.get(coord) != WALL
  end

  def room_label(coord, map)
    return unless in_room?(coord, map)
    case coord[:x]
    when AX then A
    when BX then B
    when CX then C
    when DX then D
    else nil
    end
  end

  def at_door?(coord, map)
    return unless coord[:y] == Y0
    [AX, BX, CX, DX].includes?(coord[:x])
  end

  def in_hallway?(coord, map)
    coord[:y] == Y0
  end

  def blocked_home_by?(char, coord, blocker, map)
    raise "invalid coord in #blocked_home_by?" unless coord[:y] == 1
    raise "invalid blocker in #blocked_home_by?" unless blocker[:y] == 1
    door = 
      case char
      when A then {x: AX, y: Y0}
      when B then {x: BX, y: Y0}
      when C then {x: CX, y: Y0}
      when D then {x: DX, y: Y0}
      else
        raise "???"
      end
    hallway_blocked_by?(coord, door, blocker, map)
  end

  def hallway_blocked_by?(coord, dest, blocker, map)
    raise "invalid coord in #hallway_blocked_by?" unless coord[:y] == 1
    raise "invalid dest in #hallway_blocked_by?" unless dest[:y] == 1
    raise "invalid blocker in #hallway_blocked_by?" unless blocker[:y] == 1

    c = coord
    b = blocker
    d = dest
    (c[:x] < b[:x] && b[:x] < d[:x]) || (d[:x] < b[:x] && b[:x] < c[:x])
  end

  def open_path?(from, to, map, me)
    hallway_open?(from[:x], to[:x], map, me) &&
      open_path_to_hallway?(from, map, me) &&
      open_path_to_hallway?(to, map, me)
  end

  def hallway_open?(x1, x2, map, me)
    min = [x1, x2].min
    max = [x1, x2].max
    (min..max).all? do |x|
      c = {x: x, y: 1}
      next true if c == me
      map.get(c) == OPEN
    end
  end

  def open_path_to_hallway?(coord, map, me)
    x = coord[:x]
    y = coord[:y]
    (1..y).all? do |y|
      c = {x: x, y: y}
      next true if c == me
      map.get(c) == OPEN
    end
  end

  def correct_count(map, locks)
    correct = 0
    y_values = [Y1, Y2]
    if expanded_map?(map)
      y_values << Y3
      y_values << Y4
    end
    y_values.reverse!
    {A => AX, B => BX, C => CX, D => DX}.each do |amp, x|
      y_values.each do |y|
        char = map.get({x: x, y: y})
        if char == amp
          correct += 1
          next
        else
          break
        end
      end
    end
    correct
  end

  def room_done?(amp, map)
    x =
      case amp
      when A then AX
      when B then BX
      when C then CX
      when D then DX
      else
        raise "invalid amp in #room_done?"
      end

    spots = [
      {x: x, y: Y1},
      {x: x, y: Y2}
    ]

    if expanded_map?(map)
      spots << {x: x, y: Y3}
      spots << {x: x, y: Y4}
    end
    
    spots.all? do |spot|
      map.get(spot) == amp
    end
  end

  def expanded_map?(map)
    map.get({x: 2, y: 6}) == WALL
  end

  def done?(map)
    room_done?(A, map) && room_done?(B, map) && room_done?(C, map) && room_done?(D, map)
  end

  def run_step_queue(map)
    locks = Map.new
    y_values = [Y1, Y2]
    if expanded_map?(map)
      y_values << Y3
      y_values << Y4
    end
    y_values.reverse!
    {A => AX, B => BX, C => CX, D => DX}.each do |amp, x|
      y_values.each do |y|
        coord = {x: x, y: y}
        char = map.get(coord)
        if char == amp
          locks.set(coord, DONE)
          next
        else
          break
        end
      end
    end

    first_step = {
      map: map,
      locks: locks,
      prev_map: nil,
      prev_locks: nil,
      correct_count: correct_count(map, locks),
      total_energy: 0,
      energy: 0,
    }

    @step_queue = [] of Step
    @step_queue << first_step
    @step_queue_done_steps = [] of Step
    @step_queue_all_steps = Hash(Map, Array(Step)).new
    @step_queue_all_steps[map] = [first_step] of Step

    #@run_step = BigInt.new(0)
    until @step_queue.empty? #|| @step_queue_done_steps.size > 3
      @step_queue = @step_queue.sort_by { |step| [ step[:correct_count], step[:total_energy] ] }.reverse
      run_step @step_queue.shift
    end
  end

  def run_step(step : Step)
    #@run_step += 1
    #debug @run_step
    map = step[:map]
    locks = step[:locks]
    total_energy = step[:total_energy]

    potential_moves(map, locks).each do |move|
      energy2 = move[:energy]
      total_energy2 = total_energy + energy2

      map2 = map.clone
      locks2 = locks.clone

      map2.set(move[:from], OPEN)
      map2.set(move[:to], move[:amp])

      locks2.remove(move[:from], OPEN)
      locks2.set(move[:to], LOCKED) if move[:lock]
      locks2.set(move[:to], DONE) if move[:done]

      next if unwinnable?(map2, locks2)

      correct_count2 = correct_count(map2, locks2)

      step = {
        map: map2,
        locks: locks2,
        prev_map: map,
        prev_locks: locks,
        correct_count: correct_count2,
        total_energy: total_energy2,
        energy: energy2
      }

      if done?(map2)
        @step_queue_done_steps << step
        return
      end

      if @step_queue_all_steps.has_key?(map2)
        @step_queue_all_steps[map2] << step
        next
      else
        @step_queue_all_steps[map2] = [step] of Step
      end

      #debug "completions: #{@step_queue_done_steps.size}"
      #debug "queue size: #{@step_queue.size}"
      #debug "q = #{@step_queue.size} (x = #{@run_step})"

      @step_queue.push step
    end
  end

  def solve(map)
    run_step_queue(map)

    winners = [] of NamedTuple(steps: Array(Step), energy: Int32)
    #debug "#{step_queue_done_steps.size} done steps"
    step_queue_done_steps.each do |done_step|
      steps = [done_step]
      energy = 0
      loop do
        step = steps[-1]
        break if step[:prev_map].nil? && step[:prev_locks].nil?
        energy += step[:energy]
        prev_step = @step_queue_all_steps[step[:prev_map]].sort_by { |s| s[:total_energy] }.first
        raise "step nil" if prev_step.nil?
        steps << prev_step
      end
      winners << {steps: steps.reverse, energy: energy}
    end

    winners.sort_by! { |m| m[:energy] }
    winner = winners[0]
    winner[:energy]
  end

  def part1(map)
    solve(map)
  end

  def part2(map)
    solve(map)
  end
end
