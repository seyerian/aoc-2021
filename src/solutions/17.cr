class Aoc2021::Seventeen < Aoc2021::Solution
  def parse_input(file)
    line = File.read_lines(file)[0]
    m = line.match(/target area: x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)/)
    raise "target is nil" if m.nil?
    ProbeCannon.new({
      x1: m[1].to_i32,
      x2: m[2].to_i32,
      y1: m[3].to_i32,
      y2: m[4].to_i32
    })
  end

  class Probe
    getter x_vel : Int32,
           y_vel : Int32,
           x_vel_0 : Int32,
           y_vel_0 : Int32,
           x_pos : Int32,
           y_pos : Int32,
           max_height : Int32

    def initialize(@x_vel, @y_vel)
      @x_pos = 0
      @y_pos = 0
      @max_height = 0
      @x_vel_0 = @x_vel
      @y_vel_0 = @y_vel
    end

    def step
      @x_pos += @x_vel
      @y_pos += @y_vel
      unless @x_vel == 0
        @x_vel += @x_vel > 0 ? -1 : 1
      end
      @y_vel -= 1

      if @y_pos > @max_height
        @max_height = @y_pos 
      end
    end
  end

  class ProbeCannon
    getter target : NamedTuple(x1: Int32, x2: Int32, y1: Int32, y2: Int32)
    property min_x : Int32,
             max_x : Int32,
             min_y : Int32,
             max_y : Int32

    def initialize(@target)
      @min_x = [@target[:x1], @target[:x2]].min
      @max_x = [@target[:x1], @target[:x2]].max
      @min_y = [@target[:y1], @target[:y2]].min
      @max_y = [@target[:y1], @target[:y2]].max
    end

    def test_target
      on_target = [] of Probe
      (0..max_x).each do |x_vel|
        (min_y..100).each  do |y_vel|
          probe = Probe.new(x_vel, y_vel)
          until probe.x_pos > max_x || probe.y_pos < min_y
            probe.step
            x = probe.x_pos
            y = probe.y_pos
            if x >= @min_x && x <= @max_x && y >= @min_y && y <= @max_y
              on_target << probe unless on_target.includes?(probe)
            end
          end
        end
      end
      {
        on_target: on_target,
        max_height: on_target.sort_by(&.max_height).reverse.first.max_height,
      }
    end
  end

  def part1(cannon)
    cannon.test_target[:max_height]
  end

  def part2(cannon)
    cannon.test_target[:on_target].size
  end
end
