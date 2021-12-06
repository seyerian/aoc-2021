class Aoc2021::Six < Aoc2021::Solution
  def parse_input(file)
    File.read_lines(file).first.split(',').map(&.to_u8)
  end

  def part1(timers)
    #simulate(timers, 80)
    #calculate(timers, 18)
    #calculate(timers, 80)
    #calculate_recursive(timers, 18)
    calculate_recursive(timers, 80)
  end

  def part2(timers)
    #calculate(timers, 256)
    calculate_recursive(timers, 256)
  end

  #def simulate(timers, days : Int32)
  #  baby_timers = [] of Int32
  #  days.times do |i|
  #    #debug "Initial state: #{timers.join(',')}"
  #    timers.each.with_index do |timer, i|
  #      new_timer = timer - 1
  #      if new_timer == -1
  #        new_timer = 6 
  #        baby_timers.push 8
  #      end
  #      timers[i] = new_timer
  #    end
  #    timers.concat baby_timers
  #    baby_timers.delete_at 0, baby_timers.size
  #    #debug "After #{i+1} day: #{timers.join(',')}"
  #  end
  #  timers.size
  #end

  #def calculate(timers, days : Int32)
  #  resolved_count = 0
  #  fish = timers.map { |t| { day: 0, timer: t } }
  #  baby_fish = [] of { day: Int32, timer: Int32 }
  #  until fish.empty?
  #    until fish.empty?
  #      baby_fish.concat reproduce(fish.shift, days)
  #      resolved_count += 1
  #    end
  #    fish.concat baby_fish
  #    baby_fish.delete_at 0, baby_fish.size
  #  end
  #  resolved_count
  #end

  def reproduce(fish, days)
    time = (fish[:day] + fish[:timer] + 1).to_u16
    times = time <= days ? [time] : [] of UInt16
    until time > days
      time += 7
      times << time if time <= days
    end
    times.map { |t| { day: t.to_u16, timer: 8.to_u8 } }
  end

  def calculate_recursive(timers, days : Day)
    fishes = timers.map { |t| { day: 0.to_u16, timer: t.to_u8 } }
    sum = 0_u64
    fishes.each do |fish|
      sum += calc_children(fish, days)
    end
    sum
  end

  alias Day = UInt16
  alias Timer = UInt8
  alias Fish = { day: Day, timer: Timer }
  @@calc_children_cache = Hash(Day, Hash(Fish, UInt64)).new
  def calc_children(fish, days : Day)
    @@calc_children_cache[days] ||= Hash(Fish, UInt64).new
    if (cached_sum = @@calc_children_cache[days][fish]?)
      return cached_sum
    end
    children = reproduce(fish, days)
    sum = 1_u64
    return sum if children.size == 0
    children.each do |child|
      sum += calc_children(child, days)
    end
    @@calc_children_cache[days][fish] = sum
    sum
  end
end
