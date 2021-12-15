require "../helpers/map"

class Aoc2021::Eleven < Aoc2021::Solution
  class Octopuses < Map
    property flashes
    def initialize(map : Array(Array(Char)))
      super(map)
      @flashes = Array(Array(Coord)).new
    end
    
    def step
      flashes << [] of Coord
      each do |octo, coord|
        set(coord, octo + 1)
      end
      each do |octo, coord|
        flash(coord) if octo > 9
      end
      flashes.last.each do |coord|
        set(coord, 0)
      end
    end

    def flash(coord)
      return if flashes.last.includes?(coord)
      flashes.last << coord
      neighbors(coord).each do |nb|
        inc(nb)
        if (val = get(nb))
          flash(nb) if val > 9
        end
      end
    end

    def last_flash_count
      flashes.last.size
    end

    def flash_count
      flashes.flatten.size
    end
  end

  def parse_input(file)
    Octopuses.new(InputParsers.map(file))
  end

  def part1(octos)
    100.times do |i|
      octos.step
    end
    octos.flash_count
  end

  def part2(octos)
    last = 0
    loop do
      last = last + 1
      octos.step
      break if octos.last_flash_count == 100
    end
    last
  end
end
